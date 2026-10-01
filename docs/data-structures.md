# Quorivell data structures

Canonical catalog of **what is persisted**, **where**, and **how a future
Firestore mirror must look**. Product architecture (features, layers, routing,
privacy principles, delivery) lives in [architecture.md](architecture.md).
This file is the data map those layers implement.

Drift is the canonical store. `firestore.rules` is the UID-scoped **mirror
contract** for a future sync writer — not a live sync engine. There is no
`cloud_firestore` client writer, no `lib/core/network/`, and no production
seed documents.

Keep Drift, Freezed entities, and `firestore.rules` in lockstep whenever
persisted user data changes. Executable bounds: `firestore.rules`,
`firestore.indexes.json`, `storage.rules`. Emulator tests: `firebase/test`.
Schema source: `lib/core/database/app_database.dart` (current
**schemaVersion: 11**).

## 1. Classification

| Classification | Store locally | Firestore |
| --- | --- | --- |
| **Mirrorable user data** | Drift table/column with `userId` (when the row is user-owned), `createdAt`, `updatedAt`, `isDeleted`, `syncStatus` | Yes — exact allowed keys under `users/{userId}/...` |
| **Device-local only** | Drift, SharedPreferences, files, or session state | **No** — listed in [§5](#5-device-local-exceptions) |

Default new user-facing persisted data to **mirrorable**. Device-local requires
an explicit exception here.

**Never put in a Firestore document body:** `id` (the document path carries it)
and `syncStatus` (local bookkeeping). Nested `evidence` has no `userId` column;
ownership is the parent ledger item path.

## 2. `id` and `syncStatus` rules

Mirrorable Drift tables use:

| Column | Meaning |
| --- | --- |
| `id` | String UUID v4, except singletons `app` (user preferences) and `ai_processing_consent` |
| `userId` | Stable local scope id (before optional account) |
| `createdAt` / `updatedAt` | Integer Unix epoch milliseconds locally; Firestore timestamps in the mirror |
| `isDeleted` | Soft-delete flag |
| `syncStatus` | `0` pending, `1` synced, `2` error — **local only**, never uploaded |

On mirrorable create/update/soft-delete, refresh `updatedAt` and set
`syncStatus` to pending. A future sync worker would query pending rows, write
the [§4](#4-firestore-mirror-contract) shape, and mark synced. Failed remote
work must keep the local record.

Domain Freezed entities omit `syncStatus` (and often `isDeleted`); those stay
persistence concerns.

## 3. Local ↔ Firebase parity map

| Drift table | Freezed entity | Firestore path | Notes |
| --- | --- | --- | --- |
| `local_user_scopes` | `LocalUserScope` | — | Device-local. No collection. |
| `source_conversations` | `SourceConversation` | `users/{userId}/source_conversations/{id}` | Raw capture text |
| `ledger_items` | `LedgerItem` | `users/{userId}/ledger_items/{id}` | `kind` is a catalog slug; optional `note` and `kindDisplayNameSnapshot` |
| `evidence` | `EvidenceReference` | `users/{userId}/ledger_items/{ledgerItemId}/evidence/{id}` | No `userId` in body |
| `extraction_candidates` | `ReviewCandidate` | `users/{userId}/extraction_candidates/{id}` | Rejected rows stay until soft-deleted; optional `note` |
| `extraction_runs` | `ExtractionRun` | `users/{userId}/extraction_runs/{id}` | JSON `enabledKindSlugsJson` / `kindCountsJson`; write-once counts |
| `extraction_item_kinds` | `ExtractionItemKind` | `users/{userId}/extraction_item_kinds/{id}` | Built-in ids `decision` / `commitment`; custom UUID |
| `chat_threads` | `AiChatThread` | `users/{userId}/chat_threads/{id}` | |
| `chat_messages` | `AiChatMessage` | `users/{userId}/chat_threads/{threadId}/chat_messages/{id}` | Nested under thread |
| `user_preferences` | `UserPreference` | `users/{userId}/user_preferences/{id}` | Document id `app` |
| `ai_processing_consents` | `AiProcessingConsent` | `users/{userId}/ai_processing_consents/{id}` | Document id `ai_processing_consent` |
| `extraction_jobs` | `ExtractionJob` | — | Device-local singleton `active` |

There is **no** `meeting_notes` collection. `users/{userId}` profile documents
are **denied**. `storage.rules` is total deny-all.

Single-field index exemptions in `firestore.indexes.json` match Drift/Freezed
names: `content` on `source_conversations`, `quoteSnippet` on `evidence` and
`extraction_candidates`, `content` on `chat_messages`, debug prompt override strings on
`user_preferences`, `extractionHint` and `teachingExamplesJson` on
`extraction_item_kinds`.

`AuthUser` is a Firebase Auth domain type, not a Drift table. `ExtractionProgress`
/ `ExtractionMetrics` are derived in memory from `ExtractionJob`, not stored.

## 4. Firestore mirror contract

`firestore.rules` pins the shape a future UID-scoped writer must satisfy.
Passing emulator tests does not mean sync works. Nested paths stay under
`users/{userId}/...`.

```text
users/{userId}                                          # denied (no profile doc)
users/{userId}/source_conversations/{id}
users/{userId}/ledger_items/{id}
users/{userId}/ledger_items/{id}/evidence/{evidenceId}
users/{userId}/extraction_candidates/{id}
users/{userId}/extraction_runs/{id}
users/{userId}/extraction_item_kinds/{id}
users/{userId}/chat_threads/{id}
users/{userId}/chat_threads/{id}/chat_messages/{id}
users/{userId}/user_preferences/{id}                    # id `app`
users/{userId}/ai_processing_consents/{id}              # id `ai_processing_consent`
```

Allowed keys (no `id`, no `syncStatus`):

### `source_conversations/{id}`

`userId` (immutable), `content` (1..20000), `sourceUrl` (optional http(s)
URL, 1..2000), `sourceRevision` (>= 1, non-decreasing), `createdAt`
(immutable), `updatedAt`, `isDeleted`, `isArchived`.

### `ledger_items/{id}`

`userId` (immutable), `kind` (catalog slug `^[a-z][a-z0-9_]{0,31}$`, immutable),
`statement` (1..2000), `status` (`open` \| `completed` \| `cancelled`), `owner`
(optional, 1..200), `dueDate` (optional timestamp; null when that kind’s date
policy is `none`), `note` (optional 1..2000, user-authored),
`kindDisplayNameSnapshot` (1..80), `createdAt` (immutable), `updatedAt`,
`isDeleted`.

### `ledger_items/{id}/evidence/{evidenceId}`

`ledgerItemId` (immutable, matches path), `sourceConversationId` (immutable),
`sourceRevision` (immutable), `quoteStart` / `quoteEnd` (immutable span ≤ 2000),
`quoteSnippet` (1..2000, immutable), `createdAt` (immutable), `updatedAt`,
`isDeleted`. No `userId`.

### `extraction_candidates/{id}`

`userId` (immutable), `sourceConversationId` / `sourceRevision` (immutable),
`kind` (catalog slug, immutable), `statement`, `owner`, `dueDate` (null when
the kind’s date policy is `none`), optional `note` (user-authored; model notes
are ignored), quote
anchor fields (immutable), `reviewStatus` (`pending` \| `accepted` \| `rejected`
\| `deferred`; `accepted` and `rejected` are terminal on update), `createdAt`
(immutable), `updatedAt`, `isDeleted`.

### `extraction_runs/{id}`

`userId` (immutable), `sourceConversationId` (optional, never raw content),
`sourceConversationTitle` (optional), `modelId`, `modelDisplayName` (optional),
`startedAt` / `completedAt` / `status` / `durationMs` /
`enabledKindSlugsJson` / `kindCountsJson` (immutable completion snapshot),
`acceptedCount` / `rejectedCount` / `pendingCount`, `createdAt` (immutable),
`updatedAt`, `isDeleted`.

### `extraction_item_kinds/{id}`

`userId` (immutable), `slug` (immutable, `^[a-z][a-z0-9_]{0,31}$`),
`displayName` (1..80), `extractionHint` (optional 1..400), `behavior`
(`record` \| `completable`), `datePolicy` / `notePolicy` / `ownerPolicy`
(`none` \| `optional`), `enabledForExtraction`, `isBuiltIn` (immutable),
`sortOrder` (0..1000), `teachingExamplesJson` (optional 1..4000), `createdAt`
(immutable), `updatedAt`, `isDeleted`. Built-in document ids are `decision`
and `commitment`. No `id` or `syncStatus` in the body. Conflict policy for a
future writer: last-write-wins on `updatedAt` per document.

### `chat_threads/{id}`

`userId` (immutable), `title` (1..200), `modelId` (optional), `createdAt`
(immutable), `updatedAt`, `isDeleted`.

### `chat_threads/{threadId}/chat_messages/{id}`

`userId` (immutable), `threadId` (immutable, matches path), `role` (`user` \|
`assistant`, immutable), `content` (1..20000), `status` (`complete` \| `error`),
`createdAt` (immutable), `updatedAt`, `isDeleted`.

### `user_preferences/{id}` (document id `app`)

`userId` (immutable), `themeMode` (`system` \| `light` \| `dark`),
`localePreference` (`system` \| `en` \| `de` \| `ar`), `debugModeEnabled` (bool,
required), `extractionKindsIntroDismissed` (bool, required), optional nullable
prompt overrides (1..20000 if present):
`chatSystemPromptOverride`, `extractionPromptOverride`,
`extractionSystemPromptOverride`, `createdAt` (immutable), `updatedAt`,
`isDeleted`.

Prompt override keys may be omitted or null (ARB defaults). Empty strings are
rejected. Debug mode and overrides are **mirrorable user configuration**, not
device-local exceptions.

### `ai_processing_consents/{id}` (document id `ai_processing_consent`)

`userId` (immutable), `status` (`unknown` \| `granted` \| `declined`),
`createdAt` (immutable), `updatedAt`, `isDeleted`. On-device extraction does not
read this row.

## 5. Device-local exceptions

Do **not** invent Firestore collections for these.

| Store | Shape | Purpose |
| --- | --- | --- |
| `LocalUserScopes` / `LocalUserScope` | `id`, `createdAt`, `updatedAt` | Stable local identity before optional account |
| SharedPreferences `has_seen_welcome` | bool | Welcome / first-run |
| SharedPreferences `has_completed_model_setup` | bool | Onboarding model step |
| SharedPreferences `notification_permission_prompt_decision` | `neverAsked` \| `deferred` \| `requested` | Notification prompt |
| SharedPreferences `app_update_deferred_until_ms` | int (UTC epoch ms) | In-app update dialog snooze end |
| SharedPreferences `app_update_snoozed_version` | string (marketing version) | Version that was deferred with Later |
| GGUF file + sidecars | See [§8](#8-on-device-model-files) | Weights and install metadata |
| `extraction_jobs` / `ExtractionJob` | Singleton id `active` | In-flight extract checkpoint |
| Chat auto-scroll pin | `ChatSessionState.autoScrollEnabled` | Session UI only; not Drift |
| Android Auto Backup / D2D | Disabled in the app | Must not copy Drift or GGUFs off device |

Legacy SharedPreferences `theme_mode` is migrated into Drift `user_preferences`
on first read and then removed. Do not keep account prefs only in
SharedPreferences.

User-initiated export is not shipped yet.

### `extraction_jobs` (not mirrored)

Columns: `id` (`active`), `sourceConversationId`, `sourceRevision`,
`completedChunkCount`, `totalChunks`, `candidatesFound`, `startTimeMs`,
`chunkTimingsJson`, `progressTitle`, `progressBody`, `completionTitle`,
`queuedSourceConversationIdsJson`, `batchIndex`, `batchTotal`, `createdAt`,
`updatedAt`. No `userId`, `isDeleted`, or `syncStatus`.

## 6. Drift tables and Freezed entities

Local SQLite file: `quorivell_local.sqlite` in application documents.

### `source_conversations` → `SourceConversation`

`id`, `userId`, `content`, `sourceUrl` (optional; original webpage when Capture
fetched page text), `sourceRevision`, `createdAt`, `updatedAt`, `isArchived`
(default false). Persistence also has `isDeleted`, `syncStatus`.

### `ledger_items` → `LedgerItem`

`id`, `userId`, `kind` (catalog slug string; built-in constants
`LedgerItemKind.decision` / `commitment`), `statement`, `status`
(`LedgerItemStatus`: `open` / `completed` / `cancelled`), `owner`, `dueDate`,
`note`, `kindDisplayNameSnapshot`. Limits: statement 2000, owner 200, note
2000, snapshot 80. Persistence also has `isDeleted`, `syncStatus`.

### `evidence` → `EvidenceReference`

`id`, `ledgerItemId`, `sourceConversationId`, `sourceRevision`, `quoteStart`,
`quoteEnd`, `quoteSnippet`. Persistence also has timestamps, `isDeleted`,
`syncStatus`.

### `extraction_candidates` → `ReviewCandidate`

`id`, `userId`, `sourceConversationId`, `sourceRevision`, `kind` (catalog slug),
`statement`, `owner`, `dueDate`, optional `note`, quote anchors,
`reviewStatus` (`ReviewStatus`: `pending` / `accepted` / `rejected` / `deferred`).
Persistence also has timestamps, `isDeleted`, `syncStatus`.

### `extraction_runs` → `ExtractionRun`

`id`, `userId`, `sourceConversationId`, `sourceConversationTitle`, `modelId`,
`modelDisplayName`, `startedAt`, `completedAt`, `status` (`success` / `failure`),
`durationMs`, `enabledKindSlugsJson`, `kindCountsJson`, `acceptedCount`,
`rejectedCount`, `pendingCount`. Domain getters `decisionCount` /
`commitmentCount` read those maps. Persistence also has `createdAt`, `updatedAt`,
`isDeleted`, `syncStatus`.

### `extraction_item_kinds` → `ExtractionItemKind`

`id` (built-in: `decision` / `commitment`; custom: UUID v4), `userId`, `slug`,
`displayName`, `extractionHint`, `behavior`, `datePolicy`, `notePolicy`,
`ownerPolicy`, `enabledForExtraction`, `isBuiltIn`, `sortOrder`,
`teachingExamplesJson`, timestamps. Persistence also has `isDeleted`,
`syncStatus`. Caps: 12 catalog kinds, 8 enabled, 1 enabled minimum, 3 teaching
examples. Seeded on create/upgrade and first catalog read. Clear-app-data
**keeps** this table.

### `chat_threads` → `AiChatThread`

`id`, `userId`, `title`, `modelId`, `createdAt`, `updatedAt`. Persistence also
has `isDeleted`, `syncStatus`.

### `chat_messages` → `AiChatMessage`

`id`, `userId`, `threadId`, `role` (`AiChatRole`: `user` / `assistant`),
`content`, `status` (`AiChatMessageStatus`: `complete` / `error`), timestamps.
Persistence also has `isDeleted`, `syncStatus`.

### `user_preferences` → `UserPreference`

Singleton row id `app`. See [§7](#7-debug-mode-and-ai-prompt-overrides).

### `ai_processing_consents` → `AiProcessingConsent`

Drift: `id` (`ai_processing_consent`), `userId`, `status`, `createdAt`,
`updatedAt`, `isDeleted`, `syncStatus`. Domain entity currently exposes
`status` and `updatedAt` only (`unknown` / `granted` / `declined`).

### `local_user_scopes` → `LocalUserScope`

`id`, `createdAt`, `updatedAt`. Device-local.

### `extraction_jobs` → `ExtractionJob`

See [§5](#5-device-local-exceptions).

Clear-app-data (`AppDatabase.clearUserContent`) deletes conversations, ledger,
evidence, candidates, chat, extraction jobs/runs. It **keeps** local user
scope, user preferences (including debug/prompt overrides and
`extractionKindsIntroDismissed`), AI-processing consent, and the extraction
kind catalog. It does not touch SharedPreferences or GGUF files.

Schema 11 migration adds `extraction_item_kinds`, ledger/candidate `note`,
ledger `kindDisplayNameSnapshot`, run JSON slug/count fields (replacing
`decisionCount` / `commitmentCount`), and `extractionKindsIntroDismissed`.
Schema 10 added `debugModeEnabled` and the three nullable prompt override
columns on `user_preferences`.

## 7. Debug mode and AI prompt overrides

Account → Debug mode stores **mirrorable** configuration on the same
`UserPreference` row as theme and locale. Not SharedPreferences. Not a separate
table.

| Field | Drift / domain | Firestore | Role |
| --- | --- | --- | --- |
| `debugModeEnabled` | `bool`, default `false` | required bool | When true: JSON peek panels on Review and Ledger |
| `extractionKindsIntroDismissed` | `bool`, default `false` | required bool | One-time Review banner for configurable kinds |
| `chatSystemPromptOverride` | `String?` | optional string 1..20000 | On-device chat system prompt |
| `extractionSystemPromptOverride` | `String?` | optional string 1..20000 | Extraction system prompt |
| `extractionPromptOverride` | `String?` | optional string 1..20000 | Extraction user prompt; `{conversation}` is replaced with source text |

`applyAiPromptOverrides` in `lib/core/l10n/local_ai_copy.dart` applies
non-empty overrides even when `debugModeEnabled` is false. Empty or
whitespace-only values keep the ARB default. Turning debug off hides JSON
panels and does **not** clear stored overrides or stop applying them. Daily
editing lives under Account → Extraction settings. Overrides never enable
cloud AI or auto-ledger writes. A future sync writer may upload them under
`users/{userId}/user_preferences/app` using the keys above — still no `id` or
`syncStatus` in the body. Kinds are never stored in SharedPreferences.

Chat auto-scroll remains session-only (`ChatSessionState.autoScrollEnabled`).

## 8. On-device model files

GGUF weights stay device-local. No Firestore collection.

App documents path for the recommended file:
`models/Qwen2.5-1.5B-Instruct-Q4_K_M.gguf`.

Sidecars next to the GGUF: `.part` / `.part.meta` (resumable download; meta
line 2 is catalog `modelId` so a different GGUF is not Range-appended onto the
same temp file), `.part.status` / `.part.cancel` (Android native transfer;
dropped with other temps when a model is already installed), `.import.part` /
`.import.part.meta` (resumable local copy; meta may hold a persistable SAF
URI), `.verified` (digest + length; `imported`/`advisory` when digest
skipped), `.origin` (`download`/`import`), `.identity` (display id).
Catalog/checksum source of truth for official downloads:
`lib/core/ai/local_model_spec.dart`. Runtime install ops:
[architecture Appendix A](architecture.md#appendix-a-on-device-model-ops).
