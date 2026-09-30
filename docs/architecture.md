# Quorivell Implementation Architecture

## 1. Brand, promise, and scope

- **Product name:** Quorivell
- **Product promise:** Decisions, with evidence.
- **One-line description:** Turn rough conversations into decisions you can verify.

Quorivell is a private, local-first tool for remembering what was decided, who
owns the next step, and what source evidence supports it. It is not a generic
note app, project manager, task list, or open-ended AI chat. Differentiation:
explicit evidence, human review, and private local ownership.

**Approved vocabulary:** source conversation, candidate, evidence, review,
decision, commitment, owner, due date, open commitments, extraction kind.
Shipped extraction defaults to Decision and Commitment; users may add, disable,
and hint other kinds for daily use. Prefer concrete wording (“Review the
evidence before saving”, “No owner stated”). Avoid claims that the app knows,
decides, infers, automates, or guarantees more than the source supports.

The product is local-first: Drift on device remains canonical and usable
offline. Firebase Authentication and Firestore mirroring are version-one
*foundation intent*, but source content stays local unless a documented,
explicit remote flow permits it. GenUI may appear only as a bounded review
surface with a small catalog of approved components—and is not wired today
(§3.0).

Shipped: local capture, on-device extraction of the enabled kind catalog
(Decision and Commitment built-in), human review, and evidence-backed ledger.

## 2. Core technology stack

- **Framework:** Flutter (Android targeting for v1)
- **State Management & DI:** Riverpod (`@riverpod` generators)
- **Routing:** GoRouter
- **Local Storage (Canonical):** Drift (SQLite), offline-first
- **Local AI Inference:** llama.cpp via `llama_cpp_dart` 0.2.2. Qwen2.5-1.5B-Instruct Q4_K_M is the recommended GGUF; other instruct GGUF files can be downloaded or imported when the device has enough memory. Inference runs on a background isolate. Extraction is blocked until a model is configured. There is **no keyword fallback**.
- **Firebase v1 Foundation:** Firebase Authentication is wired through the data layer. Firestore mirroring is *intent*: deny-by-default rules describe the UID-scoped document contract; there is **no client sync writer**.

## 3. Layered application structure

This is the actual tree. Do not document folders that are not in the repo.

```text
lib/
├── core/
│   ├── ai/                     # LocalAIService, llama.cpp runtime, GGUF store
│   ├── config/                 # Firebase bootstrap + App Check activation
│   ├── database/               # Drift SQLite (canonical store)
│   ├── error/                  # Sealed Freezed failures
│   ├── routing/                # GoRouter + app shell
│   └── theme/                  # Material 3 theme and spacing
├── features/
│   ├── auth/                   # Local user scope + Firebase Auth data source
│   ├── meeting_notes/          # Capture + source conversation history
│   ├── assistant/              # Extraction + pending review candidates
│   ├── extraction_kinds/       # Configurable kind catalog
│   ├── chat/                   # On-device free-form chat threads
│   └── ledger/                 # Accepted decisions, commitments, evidence
├── l10n/
├── firebase_options.dart
└── main.dart
```

`lib/core/error/` is the typed-failure surface: barrel `failures.dart` plus
`AppFailure`, `AuthFailure`, `LocalPersistenceFailure`, `RemoteFailure`,
`ExtractionFailure`, `ChatFailure`, `local_persistence_guard.dart`, and
`failure_messages.dart`. Data sources catch SDK/Drift exceptions and map them
here before they reach controllers.

Orchestration lives in presentation controllers, not widgets:
`CaptureController`, `ReviewQueueController` + `ReviewActionsController`,
`ChatSessionController`, `LedgerListController`, and `AuthController`.
Persistence goes through local data sources and a Firebase-free auth
data-source interface (`firebase_auth_remote_data_source` is the impl).
List watches (`watchAll`, `watchOpenCommitments`, `watchPending`) take
`limit`/`offset`.

`lib/core/network/` (a sync engine) is still a **planned gap**. There is no
Firestore client writer in `lib/`. Firebase App Check is activated on the
client in bootstrap; console registration and server-side enforcement are not
done. `cloud_firestore` and `cloud_functions` are not dependencies.

## 3.0 Not wired into the app

Code and config that exist in the checkout but are **not** reachable from the
running product path today. Do not treat these as shipped capabilities.

| Item | What it is | Why it is unwired |
| --- | --- | --- |
| `FirebaseAiAssistantTransport` | GenUI/`firebase_ai` chat transport under `lib/features/assistant/data/datasources/firebase_ai_assistant_transport.dart` | Unreferenced from DI, routes, or controllers. Construction throws `RemoteFailure` unless build flags, App Check enforcement, model id, and consent are all present — and nothing in the app constructs it yet. |
| `firebase_ai`, `genui`, `a2ui_core` | Pub dependencies | Only imported by the transport above (plus its unit tests). No live GenUI review surface in the shell. |
| `AppConfig.remoteAssistant` | Compile-time gates (`QUORIVELL_REMOTE_ASSISTANT_*` dart-defines) | Only consumed by the transport factory. Default build leaves remote AI disabled and unconfigured. |
| Firestore sync writer / `lib/core/network/` | Future Drift → Firestore outbox | Missing entirely. `firestore.rules` / indexes describe a mirror contract only; `syncStatus` columns are written locally and never uploaded. |
| App Check **enforcement** | Console registration + server-side require | Client activation runs in `FirebaseBootstrap`. That is not enforcement on Auth, Firestore, Functions, or Firebase AI. |
| Cloud AI request path | Off-device extraction or GenUI chat | Account consent (`AiProcessingConsent`) is persisted and shown in UI, but no code path sends source text off-device. Consent is preparatory, not an open network gate. |

## 3.1 Persisted data

Tables, entities, Firestore collection keys, device-local exceptions,
`id` / `syncStatus` rules, and sync-ready column conventions live only in
[data-structures.md](data-structures.md). Keep that catalog, Drift, and
`firestore.rules` in lockstep whenever persisted user data changes. Do not
restate field lists in this file.

## 4. Privacy and local AI boundary

Source conversation content is private user data. The app extracts **typed
candidates for the kinds you enable** on device via `LocalAIService` backed by
llama.cpp. It does not send source text to Cloud Functions, analytics, crash
reports, or third-party model APIs in local-only mode. The Android application
disables Auto Backup and cloud/device-transfer extraction of app data so Drift
records and GGUF files are not copied to Google Drive backup or another device
via system transfer.

Optional Firestore mirroring and optional Firebase AI are separate, gated
capabilities. They must not run without documented consent, authentication,
App Check, and deny-by-default rules. Account shows on-device processing, that
account sync is off, the privacy policy link, and preparatory consent UI.
On-device extraction is not blocked by consent. Remote AI remains unwired
(§3.0). Preference and consent persistence: §3.1.

`LocalAIService` accepts conversation text and returns typed candidates with
evidence spans. Default kinds are decision and commitment; users can add,
disable, and hint other kinds in the in-app catalog.
`OnDeviceLocalAIService` delegates to a `LocalTextModelRuntime`
and an `ExtractionJsonCodec`. Prompt templates stay in ARB / `LocalAICopy`
composed from the enabled catalog. Non-empty prompt overrides replace those
templates whether or not debug mode is on; they never leave the device and do
not enable cloud AI or auto-ledger writes. JSON peek panels stay behind debug.
llama.cpp FFI stays in `lib/core/ai/`. If the GGUF is missing (or an official
in-app download fails its checksum), extraction is blocked until the user
configures a model. User-selected GGUF files skip the official checksum; the
user is responsible for authenticity. Extraction surfaces
`ExtractionFailure.modelUnavailable` without a ready file.

Raw source text must stay on-device unless a documented, explicit remote flow
is wired. Catalog GGUF licenses: [licenses/README.md](licenses/README.md).
Runtime download / FGS / llama.cpp ops: [Appendix A](#appendix-a-on-device-model-ops).

## 5. Firebase reality (what is wired)

**Human provisioning (before sync or cloud AI):** legal/release owner authorizes
`com.quorivell.app`; create org-owned Firebase project(s); register the Android
package; create Native-mode Firestore and record region; enable only the Auth
provider needed for the first account slice; confirm non-secret project facts
without pasting credentials. Separate development, staging, and production
projects before release work.

**Current checkout (do not overclaim):**

- Generated Android options live in `lib/firebase_options.dart`. `main()` calls
  `FirebaseBootstrap.initialize()` only when the build opts in, and continues
  into the local-only flow when initialization fails.
- Canonical data is Drift. **No `cloud_firestore` usage in `lib/`.** No
  `functions/` tree and **no sync writer**.
- `FirebaseBootstrap` activates App Check on the client (Play Integrity on
  Android, App Attest with Device Check fallback on Apple, debug providers in
  debug builds). Console registration and server-side enforcement are in place
  (owner-confirmed 2026-09-16).
- `firestore.rules` is deny-by-default for the mirrored paths catalogued in
  §3.1. Rules pin a future mirror shape; they do not mean sync is implemented.
  `storage.rules` is deny-all; the app does not depend on `firebase_storage`.

Rules tests (JDK 21+): `cd firebase/test && npm install && npm test`
(emulator-only project id `demo-quorivell-rules`). Passing tests is not
evidence that a client sync path exists. Details:
[firebase/test/README.md](../firebase/test/README.md).

Never commit service-account keys or signing keys. Client Firebase config is
not a secret; Rules, Auth, and App Check are the security boundary.

## 6. Domain boundaries

### Feature: `auth` (identity stub)

Provides a stable local user scope before an account exists. Optional Firebase
Authentication is a version-one capability and must preserve local access,
local records, and typed failures when sign-in is unavailable.

### Feature: `meeting_notes` & `assistant`

- **Meeting Notes:** Captures text as `SourceConversation`. Android can share
  plain text into Capture; the user saves or discards. Sharing does not
  extract or sync.
- **Assistant:** `LocalAIService` produces typed candidates and does not
  decide acceptance. `ExtractionRepository` persists pending `ReviewCandidate`
  rows so Review can resume. `ledger` owns accept and manual create.

### Feature: `ledger`

Verified items and evidence (`LedgerItem`, `EvidenceReference`). Extracted
items keep that evidence at accept time. Users may also add a decision or
commitment from Ledger without a source conversation; those rows have no
evidence and must not invent quote spans. Field shapes: §3.1.

## 7. State management and data flow (offline-first)

1. UI event on a dumb page (Capture, Review, Ledger).
2. Matching Riverpod controller calls a repository. No Firebase SDK in
   presentation.
3. Repository/data source writes Drift and maps failures to `lib/core/error/`.
4. Controller exposes `AsyncValue` / Drift-backed stream. Local writes should
   not require a blocking spinner.
5. **Firebase sync engine (not implemented):** A future worker would upload
   pending local rows under the §3.1 mirror contract. Failed remote work must
   retain the local record. Do not document this as shipped.

---

<a id="appendix-a-on-device-model-ops"></a>

## Appendix A - On-device model ops

Quorivell extracts with an on-device instruct GGUF through `llama_cpp_dart`
**0.2.2** on a background isolate. Onboarding offers recommended Hugging Face
downloads, **Select model file**, or **Configure later**. Extraction stays
blocked until a GGUF is installed. Official downloads with a known SHA-256 are
verified; **Select model file** copies without that digest. Account →
**On-device model** can change or delete the file. Changing catalog model
asks for confirmation, then unloads llama.cpp and removes the current GGUF (a
matching `.part` is kept) before the new download, so a memory-mapped or
still-loaded file cannot block replace or poison SHA-256 after a retry. Resume
never concatenates a `.part` whose meta `modelId` is missing or different. Save
persists only; extraction starts from Review.

### Recommended model record

| Field | Value |
| --- | --- |
| Display / file name | `Qwen2.5-1.5B-Instruct-Q4_K_M.gguf` |
| Repository | [Qwen/Qwen2.5-1.5B-Instruct-GGUF](https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF) |
| Download URL | `https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf` |
| SHA-256 | `6a1a2eb6d15622bf3c96857206351ba97e1af16c30d7a74ee38970e434e9407e` |
| Size | ~1.12 GB |
| Context (`n_ctx`) | 4096 (Android caps at 2048 at load) |
| Max conversation characters (single-shot extract / soft cap) | 8000 |
| Max conversation characters (chunked extract hard cap) | 20000 |
| Chat format | ChatML |
| License | Apache License 2.0 for 1.5B Instruct weights — [QWEN_NOTICE.md](licenses/QWEN_NOTICE.md) |
| Approximate RAM | ~2–3 GB while loaded |

App documents path and sidecar filenames:
[data-structures.md](data-structures.md#8-on-device-model-files). Spec source
of truth: `lib/core/ai/local_model_spec.dart`. If Hugging Face replaces the
blob, update that file and the recommended-model table together.

GGUF weights stay **device-local**. They are never uploaded and have no
Firestore collection.

### Background transfer (Android)

User-started model download, local GGUF copy, extraction, and on-device
chat generation share one Play **dataSync** foreground-service type
(`ExtractionService` + WorkManager `SystemForegroundService`). Controllers
start keep-alive on the user tap while the activity is still foreground.
Widgets do not start FGS.

- **Home / app switch:** the ongoing LOW notification keeps the process alive
  (same pattern as Extract). While that FGS is running, Android keeps the
  Flutter engine when the activity is destroyed so extraction, chat
  generation, and in-app download stats continue. Tapping the notification
  reattaches the same isolate; the extraction overlay, chat thread, and live
  download stats stay on screen. Extraction / model-install / **chat
  completion** uses a separate HIGH-importance channel
  (`extraction_complete_channel_v2`) so the finish alert can sound when the
  screen is off (subject to silent mode / DND). Chat completion alerts fire
  only when the Chat transcript is not visible (another tab, Chat history,
  app minimized, or screen off) and never include message text. The Chat tab
  shows an unread count for those off-screen replies until the transcript is
  opened again (typically `1`, since only one reply generates at a time).
- **Download after process death:** HTTP runs in `ModelTransferWorker`
  (WorkManager `setForeground`, Range resume into `.part`). Unique download
  jobs use `ExistingWorkPolicy.REPLACE` so a retry or catalog switch does not
  keep a stale worker. Dart verifies SHA-256 and `installVerified`. A leftover
  complete `.part` shows a **Finalizing the model** state (indeterminate
  progress) instead of a stuck 100% bar, then auto-resumes checksum. A leftover
  incomplete `.part` auto-resumes on next launch only when `.part.meta` names
  the same catalog `modelId`. Wake lock is 60 minutes and is refreshed
  during long transfers (the previous 10-minute cap was too short for
  1.1–5 GB).
- **Local copy:** Android streams once from the SAF URI via
  `ContentResolver.openInputStream` under the same FGS (skips file_picker’s
  GB cache copy). Persistable URI permission is taken when the provider
  allows it so a killed copy can resume. `.import.part` is kept across
  restarts like `.part`. After the copy stream finishes, UI shows
  finalizing while the file is hashed and installed.
- **Swipe-away from Recents:** llama.cpp is Dart-only, so a process kill
  stops the current chunk. `ExtractionService.onTaskRemoved` cancels the
  progress notification (and stops the service) when no WorkManager model
  transfer is running, so the shade does not keep claiming extract is
  active. Official HTTP download should continue via WorkManager (FGS kept).
  Import resume needs the persistable URI (or a new pick). Extraction
  persists a device-local job (`extraction_jobs`) for the current
  conversation plus any remaining extract-all queue, and resumes remaining
  **finished** chunks (then the next queued conversation) on the next Dart
  isolate and again when the activity resumes (overlay + FGS restart). A
  leftover progress notification with no in-flight Dart extract, no
  resumable job, no in-flight chat generation, and no model transfer is
  cancelled on launch even if the native service is already dead, so the
  shade does not lie. The extraction
  overlay hint warns that Recents swipe stops work until the app is opened
  again; Home / app switch remains OK.
- **Account battery guidance:** Android always shows an Account card with a
  path into app battery settings. Restricted and system Battery Saver stay
  warnings. Xiaomi/HyperOS **Battery saver (recommended)** is not AOSP
  Restricted but is still a reminder until the app is allowlisted
  (**No restrictions**). Stock Optimized does not show a warning dialog.
- **Android 15:** `dataSync` FGS is time-capped (~6 hours / 24 hours). A 1.1 GB
  Qwen download is expected to finish inside that window; a multi-GB catalog
  model on a slow link might need the user to return and resume.
- **iOS:** not in the v1 Android repo. A future Apple build should use
  `URLSession` background downloads; do not assume the Dart `HttpClient` path
  survives suspension.

Emulator host push example:

```bat
adb push Qwen2.5-1.5B-Instruct-Q4_K_M.gguf /sdcard/Download/
```

Then **Select model file** in onboarding.

### Native llama.cpp libraries

`llama_cpp_dart` 0.2.2 does **not** embed llama.cpp. Quorivell **ships**
Android shared libraries under `android/app/src/main/jniLibs/` for
`arm64-v8a` and `x86_64`. Rebuild when refreshing the pin — full steps:
[native/building-llama-cpp.md](native/building-llama-cpp.md).

- **Windows:** Build shared `llama.dll` (+ `ggml*.dll`); place in the Flutter
  project directory or next to the executable; restart the app. Not committed.
- **Android:** jniLibs must match llama.cpp pin
  `4ffc47cb2001e7d523f9ff525335bbe34b1a2858`. Expected files per ABI:
  `libllama.so`, `libggml.so`, `libggml-base.so`, `libggml-cpu.so`, and NDK
  `libc++_shared.so`. Quorivell loads `libllama.so` and registers the CPU
  backend from `libggml-cpu.so`. Full reinstall after changing `.so` files.
  A mismatched newer tree SIGSEGVs on load.

### Runtime notes (concise)

- Debugger-attached isolate spawn can look frozen; prefer profile/release for
  timing.
- Inference leaves cores for Flutter, coalesces token IPC, and forwards only
  warn/error llama logs.
- Load timeout is extended (stock `LlamaParent` 60s is too short for ~1.1 GB).
  Android prefers `use_mmap=false` with one mmap retry; `n_gpu_layers=0`,
  `main_gpu=-1`.
