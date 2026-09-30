// Shared setup for the Quorivell rules tests.
//
// All fixture payloads below are synthetic. Never put real conversation
// content, credentials, or secrets in these files.

import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

import { initializeTestEnvironment } from '@firebase/rules-unit-testing';
import { Timestamp } from 'firebase/firestore';

const here = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(here, '..', '..', '..');

export const PROJECT_ID = 'demo-quorivell-rules';
export const OWNER_UID = 'owner-uid-0001';
export const OTHER_UID = 'other-uid-0002';

// Fixed past timestamps: the rules reject future-dated writes, and hard-coded
// values keep the suite immune to clock skew against the emulator.
export const CREATED_AT = Timestamp.fromDate(new Date('2026-01-01T00:00:00Z'));
export const UPDATED_AT = Timestamp.fromDate(new Date('2026-01-02T00:00:00Z'));
export const LATER_AT = Timestamp.fromDate(new Date('2026-01-03T00:00:00Z'));

function emulatorAddress(envVar, defaultPort) {
  const raw = process.env[envVar];
  if (!raw) {
    return { host: '127.0.0.1', port: defaultPort };
  }
  const withoutScheme = raw.replace(/^https?:\/\//, '');
  const [host, port] = withoutScheme.split(':');
  return { host: host || '127.0.0.1', port: Number(port) || defaultPort };
}

function readRules(fileName) {
  return readFileSync(resolve(repoRoot, fileName), 'utf8');
}

export function createTestEnvironment() {
  const firestore = emulatorAddress('FIRESTORE_EMULATOR_HOST', 8080);
  const storage = emulatorAddress('FIREBASE_STORAGE_EMULATOR_HOST', 9199);

  return initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: { rules: readRules('firestore.rules'), ...firestore },
    storage: { rules: readRules('storage.rules'), ...storage },
  });
}

export function anonymousContext(env, uid) {
  return env.authenticatedContext(uid, {
    firebase: { sign_in_provider: 'anonymous', identities: {} },
  });
}

export function sourceConversationPath(uid, id = 'conversation-1') {
  return `users/${uid}/source_conversations/${id}`;
}

export function ledgerItemPath(uid, id = 'ledger-item-1') {
  return `users/${uid}/ledger_items/${id}`;
}

export function evidencePath(uid, itemId = 'ledger-item-1', id = 'evidence-1') {
  return `${ledgerItemPath(uid, itemId)}/evidence/${id}`;
}

export function extractionCandidatePath(uid, id = 'candidate-1') {
  return `users/${uid}/extraction_candidates/${id}`;
}

export function chatThreadPath(uid, id = 'chat-thread-1') {
  return `users/${uid}/chat_threads/${id}`;
}

export function chatMessagePath(
  uid,
  threadId = 'chat-thread-1',
  id = 'chat-message-1',
) {
  return `${chatThreadPath(uid, threadId)}/chat_messages/${id}`;
}

export function userPreferencePath(uid, id = 'app') {
  return `users/${uid}/user_preferences/${id}`;
}

export function aiProcessingConsentPath(uid, id = 'ai_processing_consent') {
  return `users/${uid}/ai_processing_consents/${id}`;
}

export function extractionItemKindPath(uid, id = 'kind-1') {
  return `users/${uid}/extraction_item_kinds/${id}`;
}

export function extractionRunPath(uid, id = 'run-1') {
  return `users/${uid}/extraction_runs/${id}`;
}

export function validSourceConversation(uid, overrides = {}) {
  return {
    userId: uid,
    content: 'synthetic fixture: two teammates agree on a placeholder plan.',
    sourceRevision: 1,
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    isArchived: false,
    ...overrides,
  };
}

export function validLedgerItem(uid, overrides = {}) {
  return {
    userId: uid,
    kind: 'decision',
    statement: 'synthetic fixture statement',
    status: 'open',
    owner: null,
    dueDate: null,
    note: null,
    kindDisplayNameSnapshot: 'Decision',
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function validEvidence(itemId = 'ledger-item-1', overrides = {}) {
  return {
    ledgerItemId: itemId,
    sourceConversationId: 'conversation-1',
    sourceRevision: 1,
    quoteStart: 0,
    quoteEnd: 24,
    quoteSnippet: 'synthetic fixture quote',
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function validExtractionCandidate(uid, overrides = {}) {
  return {
    userId: uid,
    sourceConversationId: 'conversation-1',
    sourceRevision: 1,
    kind: 'commitment',
    statement: 'synthetic fixture candidate statement',
    owner: null,
    dueDate: null,
    note: null,
    quoteStart: 0,
    quoteEnd: 24,
    quoteSnippet: 'synthetic fixture quote',
    reviewStatus: 'pending',
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function validChatThread(uid, overrides = {}) {
  return {
    userId: uid,
    title: 'synthetic fixture chat',
    modelId: 'test-model',
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function validChatMessage(uid, threadId = 'chat-thread-1', overrides = {}) {
  return {
    userId: uid,
    threadId,
    role: 'user',
    content: 'synthetic fixture chat turn',
    status: 'complete',
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function validUserPreference(uid, overrides = {}) {
  return {
    userId: uid,
    themeMode: 'system',
    localePreference: 'system',
    debugModeEnabled: false,
    chatSystemPromptOverride: null,
    extractionPromptOverride: null,
    extractionSystemPromptOverride: null,
    extractionKindsIntroDismissed: false,
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function validAiProcessingConsent(uid, overrides = {}) {
  return {
    userId: uid,
    status: 'granted',
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function validExtractionRun(uid, overrides = {}) {
  return {
    userId: uid,
    sourceConversationId: 'conversation-1',
    sourceConversationTitle: 'Fixture conversation',
    modelId: 'test-model-id',
    modelDisplayName: 'Test Model 1.5B',
    startedAt: CREATED_AT,
    completedAt: UPDATED_AT,
    status: 'success',
    durationMs: 5000,
    enabledKindSlugsJson: '["decision","commitment"]',
    kindCountsJson: '{"decision":2,"commitment":1}',
    acceptedCount: 1,
    rejectedCount: 1,
    pendingCount: 1,
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function validExtractionItemKind(uid, overrides = {}) {
  return {
    userId: uid,
    slug: 'groceries',
    displayName: 'Groceries',
    extractionHint: 'Things we need to buy.',
    behavior: 'completable',
    datePolicy: 'optional',
    notePolicy: 'optional',
    ownerPolicy: 'none',
    enabledForExtraction: true,
    isBuiltIn: false,
    sortOrder: 2,
    teachingExamplesJson: null,
    createdAt: CREATED_AT,
    updatedAt: UPDATED_AT,
    isDeleted: false,
    ...overrides,
  };
}

export function withoutField(payload, field) {
  const copy = { ...payload };
  delete copy[field];
  return copy;
}
