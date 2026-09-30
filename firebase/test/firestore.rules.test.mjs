import assert from 'node:assert/strict';
import { after, before, beforeEach, describe, it } from 'node:test';

import { assertFails, assertSucceeds } from '@firebase/rules-unit-testing';
import {
  collectionGroup,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

import {
  CREATED_AT,
  LATER_AT,
  UPDATED_AT,
  OTHER_UID,
  OWNER_UID,
  anonymousContext,
  chatMessagePath,
  chatThreadPath,
  createTestEnvironment,
  evidencePath,
  extractionCandidatePath,
  extractionItemKindPath,
  extractionRunPath,
  ledgerItemPath,
  sourceConversationPath,
  userPreferencePath,
  aiProcessingConsentPath,
  validAiProcessingConsent,
  validChatMessage,
  validChatThread,
  validEvidence,
  validExtractionCandidate,
  validExtractionItemKind,
  validExtractionRun,
  validLedgerItem,
  validSourceConversation,
  validUserPreference,
  withoutField,
} from './support/harness.mjs';

let env;

before(async () => {
  env = await createTestEnvironment();
});

after(async () => {
  await env?.cleanup();
});

beforeEach(async () => {
  await env.clearFirestore();
});

function ownerDb() {
  return env.authenticatedContext(OWNER_UID).firestore();
}

function otherDb() {
  return env.authenticatedContext(OTHER_UID).firestore();
}

function unauthenticatedDb() {
  return env.unauthenticatedContext().firestore();
}

function anonymousDb() {
  return anonymousContext(env, OWNER_UID).firestore();
}

async function seed(path, data) {
  await env.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), path), data);
  });
}

describe('users/{userId} document', () => {
  it('denies the owner reading or writing the profile document', async () => {
    // No profile document is synced today, so this path stays fully closed.
    const db = ownerDb();
    await assertFails(getDoc(doc(db, `users/${OWNER_UID}`)));
    await assertFails(setDoc(doc(db, `users/${OWNER_UID}`), { anything: true }));
  });
});

describe('source_conversations', () => {
  const path = sourceConversationPath(OWNER_UID);

  it('denies unauthenticated read and write', async () => {
    await seed(path, validSourceConversation(OWNER_UID));
    const db = unauthenticatedDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(setDoc(doc(db, path), validSourceConversation(OWNER_UID)));
  });

  it('denies anonymous sign-in even with the owner uid', async () => {
    await seed(path, validSourceConversation(OWNER_UID));
    await assertFails(getDoc(doc(anonymousDb(), path)));
  });

  it("denies another signed-in user reading or writing the owner's conversation", async () => {
    await seed(path, validSourceConversation(OWNER_UID));
    const db = otherDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(updateDoc(doc(db, path), { content: 'intruder text' }));
    await assertFails(deleteDoc(doc(db, path)));
    await assertFails(
      setDoc(doc(db, sourceConversationPath(OWNER_UID, 'planted')), validSourceConversation(OWNER_UID)),
    );
  });

  it('allows the owner to create, read, update and delete', async () => {
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validSourceConversation(OWNER_UID)));
    const snapshot = await assertSucceeds(getDoc(doc(db, path)));
    assert.equal(snapshot.data().sourceRevision, 1);
    await assertSucceeds(
      updateDoc(doc(db, path), { content: 'synthetic revision two', sourceRevision: 2, updatedAt: LATER_AT }),
    );
    await assertSucceeds(deleteDoc(doc(db, path)));
  });

  it('allows a full-document overwrite that resends unchanged immutable fields', async () => {
    // This is how a sync writer would actually push a local record: the whole
    // document, including createdAt. Resending an identical value must not
    // trip the immutability check.
    await seed(path, validSourceConversation(OWNER_UID));
    const db = ownerDb();
    await assertSucceeds(
      setDoc(
        doc(db, path),
        validSourceConversation(OWNER_UID, {
          content: 'synthetic revision two',
          sourceRevision: 2,
          updatedAt: LATER_AT,
        }),
      ),
    );
  });

  it('allows a merge write that only touches mutable fields', async () => {
    await seed(path, validSourceConversation(OWNER_UID));
    const db = ownerDb();
    await assertSucceeds(
      setDoc(doc(db, path), { content: 'synthetic revision two', updatedAt: LATER_AT }, { merge: true }),
    );
  });

  it('denies a body whose userId does not match the caller', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { userId: OTHER_UID })),
    );
  });

  it('denies wrong field types', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { sourceRevision: '1' })),
    );
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { createdAt: 1735689600000 })),
    );
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { isDeleted: 'false' })),
    );
  });

  it('denies unknown fields, including the local-only syncStatus column', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { syncStatus: 0 })),
    );
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { extraData: 'anything' })),
    );
  });

  it('denies missing required fields', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), withoutField(validSourceConversation(OWNER_UID), 'isDeleted')),
    );
    await assertFails(
      setDoc(doc(db, path), withoutField(validSourceConversation(OWNER_UID), 'createdAt')),
    );
  });

  it('denies empty and oversized content', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validSourceConversation(OWNER_UID, { content: '' })));
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { content: 'x'.repeat(20001) })),
    );
  });

  it('denies future-dated and inverted timestamps', async () => {
    const db = ownerDb();
    const future = new Date(Date.now() + 60 * 60 * 1000);
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { updatedAt: future })),
    );
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { createdAt: LATER_AT })),
    );
  });

  it('denies mutating immutable fields on update', async () => {
    await seed(path, validSourceConversation(OWNER_UID));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { createdAt: LATER_AT, updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { userId: OTHER_UID, updatedAt: LATER_AT }));
  });

  it('denies rewinding sourceRevision', async () => {
    await seed(path, validSourceConversation(OWNER_UID, { sourceRevision: 3 }));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { sourceRevision: 2, updatedAt: LATER_AT }));
  });

  it('denies an update that corrupts the document into an invalid state', async () => {
    await seed(path, validSourceConversation(OWNER_UID));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { content: 'x'.repeat(20001), updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { syncStatus: 2, updatedAt: LATER_AT }));
  });

  it('requires a boolean isArchived flag matching the local archive state', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), withoutField(validSourceConversation(OWNER_UID), 'isArchived')),
    );
    await assertFails(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { isArchived: 'yes' })),
    );
    await assertSucceeds(
      setDoc(doc(db, path), validSourceConversation(OWNER_UID, { isArchived: true })),
    );
    await assertSucceeds(updateDoc(doc(db, path), { isArchived: false, updatedAt: LATER_AT }));
  });
});

describe('ledger_items', () => {
  const path = ledgerItemPath(OWNER_UID);

  it('denies unauthenticated read and write', async () => {
    await seed(path, validLedgerItem(OWNER_UID));
    const db = unauthenticatedDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(setDoc(doc(db, path), validLedgerItem(OWNER_UID)));
  });

  it("denies another signed-in user touching the owner's ledger", async () => {
    await seed(path, validLedgerItem(OWNER_UID));
    const db = otherDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(updateDoc(doc(db, path), { status: 'cancelled' }));
    await assertFails(deleteDoc(doc(db, path)));
  });

  it('allows the owner happy path including optional fields', async () => {
    const db = ownerDb();
    const commitmentPath = ledgerItemPath(OWNER_UID, 'ledger-commitment-1');
    await assertSucceeds(
      setDoc(doc(db, commitmentPath), validLedgerItem(OWNER_UID, { kind: 'commitment' })),
    );
    await assertSucceeds(getDoc(doc(db, commitmentPath)));
    await assertSucceeds(
      updateDoc(doc(db, commitmentPath), {
        statement: 'synthetic updated statement',
        owner: 'placeholder-owner',
        dueDate: LATER_AT,
        status: 'completed',
        updatedAt: LATER_AT,
      }),
    );
    await assertSucceeds(deleteDoc(doc(db, commitmentPath)));
  });

  it('allows groceries and optional dueDate on any slug', async () => {
    const db = ownerDb();
    await assertSucceeds(
      setDoc(
        doc(db, ledgerItemPath(OWNER_UID, 'ledger-groceries-1')),
        validLedgerItem(OWNER_UID, {
          kind: 'groceries',
          kindDisplayNameSnapshot: 'Groceries',
          dueDate: LATER_AT,
          note: 'buy oat milk',
        }),
      ),
    );
    await assertSucceeds(
      setDoc(doc(db, path), validLedgerItem(OWNER_UID, { dueDate: LATER_AT })),
    );
  });

  it('denies invalid slug values', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validLedgerItem(OWNER_UID, { kind: 'Decision' })));
    await assertFails(setDoc(doc(db, path), validLedgerItem(OWNER_UID, { kind: 'my kind' })));
    await assertFails(setDoc(doc(db, path), validLedgerItem(OWNER_UID, { kind: '' })));
    await assertFails(setDoc(doc(db, path), validLedgerItem(OWNER_UID, { status: 'archived' })));
  });

  it('denies malformed optional fields and unknown fields', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validLedgerItem(OWNER_UID, { owner: 42 })));
    await assertFails(
      setDoc(doc(db, path), validLedgerItem(OWNER_UID, { owner: 'x'.repeat(201) })),
    );
    await assertFails(setDoc(doc(db, path), validLedgerItem(OWNER_UID, { dueDate: 'tomorrow' })));
    await assertFails(setDoc(doc(db, path), validLedgerItem(OWNER_UID, { syncStatus: 1 })));
  });

  it('denies mutating immutable fields on update', async () => {
    await seed(path, validLedgerItem(OWNER_UID));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { kind: 'commitment', updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { createdAt: LATER_AT, updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { userId: OTHER_UID, updatedAt: LATER_AT }));
  });

  it('denies a status transition that skips reopening the item', async () => {
    await seed(path, validLedgerItem(OWNER_UID, { status: 'completed' }));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { status: 'cancelled', updatedAt: LATER_AT }));
    await assertSucceeds(updateDoc(doc(db, path), { status: 'open', updatedAt: LATER_AT }));
  });
});

describe('ledger_items/{id}/evidence', () => {
  const parentPath = ledgerItemPath(OWNER_UID);
  const path = evidencePath(OWNER_UID);

  it('denies unauthenticated read and write', async () => {
    await seed(parentPath, validLedgerItem(OWNER_UID));
    await seed(path, validEvidence());
    const db = unauthenticatedDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(setDoc(doc(db, path), validEvidence()));
  });

  it("denies another signed-in user reading or writing the owner's evidence", async () => {
    await seed(path, validEvidence());
    const db = otherDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(setDoc(doc(db, evidencePath(OWNER_UID, 'ledger-item-1', 'planted')), validEvidence()));
  });

  it('allows the owner to create, read, tombstone and delete', async () => {
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validEvidence()));
    await assertSucceeds(getDoc(doc(db, path)));
    await assertSucceeds(updateDoc(doc(db, path), { isDeleted: true, updatedAt: LATER_AT }));
    await assertSucceeds(deleteDoc(doc(db, path)));
  });

  it('allows a full-document overwrite that only flips the tombstone', async () => {
    await seed(path, validEvidence());
    const db = ownerDb();
    await assertSucceeds(
      setDoc(doc(db, path), validEvidence('ledger-item-1', { isDeleted: true, updatedAt: LATER_AT })),
    );
  });

  it('denies evidence pointing at a different ledger item than its parent', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validEvidence('ledger-item-1', { ledgerItemId: 'ledger-item-9' })),
    );
  });

  it('denies malformed quote anchors', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validEvidence('ledger-item-1', { quoteStart: -1 })));
    await assertFails(setDoc(doc(db, path), validEvidence('ledger-item-1', { quoteEnd: 0 })));
    await assertFails(setDoc(doc(db, path), validEvidence('ledger-item-1', { quoteEnd: '24' })));
    await assertFails(setDoc(doc(db, path), validEvidence('ledger-item-1', { quoteSnippet: '' })));
    await assertFails(
      setDoc(doc(db, path), validEvidence('ledger-item-1', { quoteSnippet: 'x'.repeat(2001) })),
    );
    await assertFails(setDoc(doc(db, path), validEvidence('ledger-item-1', { syncStatus: 0 })));
    await assertFails(setDoc(doc(db, path), withoutField(validEvidence(), 'sourceRevision')));
  });

  it('denies re-pointing an existing quote anchor', async () => {
    await seed(path, validEvidence());
    const db = ownerDb();
    await assertFails(
      updateDoc(doc(db, path), { quoteSnippet: 'synthetic replacement quote', updatedAt: LATER_AT }),
    );
    await assertFails(
      updateDoc(doc(db, path), { sourceConversationId: 'conversation-2', updatedAt: LATER_AT }),
    );
    await assertFails(updateDoc(doc(db, path), { createdAt: LATER_AT, updatedAt: LATER_AT }));
  });
});

describe('extraction_candidates', () => {
  const path = extractionCandidatePath(OWNER_UID);

  it('denies unauthenticated read and write', async () => {
    await seed(path, validExtractionCandidate(OWNER_UID));
    const db = unauthenticatedDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(setDoc(doc(db, path), validExtractionCandidate(OWNER_UID)));
  });

  it("denies another signed-in user touching the owner's candidates", async () => {
    await seed(path, validExtractionCandidate(OWNER_UID));
    const db = otherDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(updateDoc(doc(db, path), { reviewStatus: 'accepted' }));
    await assertFails(deleteDoc(doc(db, path)));
  });

  it('allows the owner to create and review', async () => {
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validExtractionCandidate(OWNER_UID)));
    await assertSucceeds(getDoc(doc(db, path)));
    await assertSucceeds(
      updateDoc(doc(db, path), {
        statement: 'synthetic corrected statement',
        reviewStatus: 'accepted',
        updatedAt: LATER_AT,
      }),
    );
    await assertSucceeds(deleteDoc(doc(db, path)));
  });

  it('allows groceries and dueDate on any candidate kind', async () => {
    const db = ownerDb();
    await assertSucceeds(
      setDoc(
        doc(db, path),
        validExtractionCandidate(OWNER_UID, {
          kind: 'groceries',
          dueDate: LATER_AT,
          note: 'user note',
        }),
      ),
    );
    await assertSucceeds(
      setDoc(
        doc(db, extractionCandidatePath(OWNER_UID, 'candidate-decision-date')),
        validExtractionCandidate(OWNER_UID, { kind: 'decision', dueDate: LATER_AT }),
      ),
    );
  });

  it('allows creating an already-reviewed candidate, because devices sync late', async () => {
    const db = ownerDb();
    await assertSucceeds(
      setDoc(doc(db, path), validExtractionCandidate(OWNER_UID, { reviewStatus: 'accepted' })),
    );
  });

  it('denies invalid enum values, wrong types and unknown fields', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validExtractionCandidate(OWNER_UID, { reviewStatus: 'maybe' })),
    );
    await assertFails(setDoc(doc(db, path), validExtractionCandidate(OWNER_UID, { kind: 'Note' })));
    await assertFails(
      setDoc(doc(db, path), validExtractionCandidate(OWNER_UID, { sourceRevision: 0 })),
    );
    await assertFails(
      setDoc(doc(db, path), validExtractionCandidate(OWNER_UID, { statement: 'x'.repeat(2001) })),
    );
    await assertFails(
      setDoc(doc(db, path), validExtractionCandidate(OWNER_UID, { syncStatus: 3 })),
    );
    await assertFails(
      setDoc(doc(db, path), withoutField(validExtractionCandidate(OWNER_UID), 'reviewStatus')),
    );
  });

  it('denies mutating provenance fields on update', async () => {
    await seed(path, validExtractionCandidate(OWNER_UID));
    const db = ownerDb();
    await assertFails(
      updateDoc(doc(db, path), { sourceConversationId: 'conversation-2', updatedAt: LATER_AT }),
    );
    await assertFails(updateDoc(doc(db, path), { quoteStart: 5, updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { kind: 'decision', updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { createdAt: CREATED_AT, userId: OTHER_UID }));
  });

  it('denies re-opening a terminal review decision', async () => {
    await seed(path, validExtractionCandidate(OWNER_UID, { reviewStatus: 'accepted' }));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { reviewStatus: 'pending', updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { reviewStatus: 'rejected', updatedAt: LATER_AT }));
  });

  it('freezes an accepted candidate except for its tombstone', async () => {
    await seed(path, validExtractionCandidate(OWNER_UID, { reviewStatus: 'accepted' }));
    const db = ownerDb();
    await assertFails(
      updateDoc(doc(db, path), { statement: 'synthetic rewritten statement', updatedAt: LATER_AT }),
    );
    await assertFails(updateDoc(doc(db, path), { owner: 'placeholder-owner', updatedAt: LATER_AT }));
    await assertSucceeds(updateDoc(doc(db, path), { isDeleted: true, updatedAt: LATER_AT }));
  });

  it('allows moving a deferred candidate forward', async () => {
    await seed(path, validExtractionCandidate(OWNER_UID, { reviewStatus: 'deferred' }));
    const db = ownerDb();
    await assertSucceeds(updateDoc(doc(db, path), { reviewStatus: 'accepted', updatedAt: LATER_AT }));
  });
});

describe('chat_threads', () => {
  const path = chatThreadPath(OWNER_UID);

  it('denies unauthenticated read and write', async () => {
    await seed(path, validChatThread(OWNER_UID));
    const db = unauthenticatedDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(setDoc(doc(db, path), validChatThread(OWNER_UID)));
  });

  it('denies another signed-in user', async () => {
    await seed(path, validChatThread(OWNER_UID));
    const db = otherDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(updateDoc(doc(db, path), { title: 'intruder', updatedAt: LATER_AT }));
  });

  it('allows the owner to create, read, update and delete', async () => {
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validChatThread(OWNER_UID)));
    await assertSucceeds(getDoc(doc(db, path)));
    await assertSucceeds(updateDoc(doc(db, path), { title: 'synthetic revision', updatedAt: LATER_AT }));
    await assertSucceeds(deleteDoc(doc(db, path)));
  });

  it('denies unknown fields such as syncStatus', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validChatThread(OWNER_UID, { syncStatus: 0 })));
    await assertFails(setDoc(doc(db, path), validChatThread(OWNER_UID, { title: 'x'.repeat(201) })));
  });
});

describe('chat_messages', () => {
  const path = chatMessagePath(OWNER_UID);

  it('allows the owner to write a turn under their thread', async () => {
    await seed(chatThreadPath(OWNER_UID), validChatThread(OWNER_UID));
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validChatMessage(OWNER_UID)));
    await assertSucceeds(getDoc(doc(db, path)));
  });

  it('denies a body whose threadId does not match the path', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validChatMessage(OWNER_UID, 'other-thread')),
    );
  });

  it('denies mutating role after create', async () => {
    await seed(path, validChatMessage(OWNER_UID));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { role: 'assistant', updatedAt: LATER_AT }));
    await assertSucceeds(updateDoc(doc(db, path), { status: 'error', updatedAt: LATER_AT }));
  });

  it('denies content over 20000 characters', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validChatMessage(OWNER_UID, 'chat-thread-1', { content: 'x'.repeat(20001) })),
    );
  });
});

describe('user_preferences', () => {
  const path = userPreferencePath(OWNER_UID);

  it('denies unauthenticated read and write', async () => {
    await seed(path, validUserPreference(OWNER_UID));
    const db = unauthenticatedDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(setDoc(doc(db, path), validUserPreference(OWNER_UID)));
  });

  it("denies another signed-in user touching the owner's preference", async () => {
    await seed(path, validUserPreference(OWNER_UID));
    const db = otherDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(updateDoc(doc(db, path), { themeMode: 'dark', updatedAt: LATER_AT }));
    await assertFails(deleteDoc(doc(db, path)));
  });

  it('allows the owner to create, update and delete appearance preference', async () => {
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validUserPreference(OWNER_UID)));
    await assertSucceeds(getDoc(doc(db, path)));
    await assertSucceeds(updateDoc(doc(db, path), { themeMode: 'dark', updatedAt: LATER_AT }));
    await assertSucceeds(
      updateDoc(doc(db, path), { localePreference: 'ar', updatedAt: LATER_AT }),
    );
    await assertSucceeds(
      updateDoc(doc(db, path), {
        debugModeEnabled: true,
        chatSystemPromptOverride: 'Stay on this device.',
        extractionPromptOverride: 'Extract only.\n\n{conversation}',
        extractionSystemPromptOverride: 'Return JSON only.',
        updatedAt: LATER_AT,
      }),
    );
    await assertSucceeds(deleteDoc(doc(db, path)));
  });

  it('allows creating debug prefs without optional prompt override keys', async () => {
    const db = ownerDb();
    await assertSucceeds(
      setDoc(doc(db, path), {
        userId: OWNER_UID,
        themeMode: 'system',
        localePreference: 'system',
        debugModeEnabled: false,
        extractionKindsIntroDismissed: false,
        createdAt: CREATED_AT,
        updatedAt: UPDATED_AT,
        isDeleted: false,
      }),
    );
  });

  it('denies invalid themeMode values, unknown fields and immutable edits', async () => {
    await seed(path, validUserPreference(OWNER_UID));
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validUserPreference(OWNER_UID, { themeMode: 'sepia' })));
    await assertFails(
      setDoc(doc(db, path), validUserPreference(OWNER_UID, { localePreference: 'fr' })),
    );
    await assertFails(setDoc(doc(db, path), validUserPreference(OWNER_UID, { syncStatus: 0 })));
    await assertFails(setDoc(doc(db, path), validUserPreference(OWNER_UID, { id: 'app' })));
    await assertFails(
      setDoc(doc(db, path), validUserPreference(OWNER_UID, {
        chatSystemPromptOverride: 'x'.repeat(20001),
      })),
    );
    await assertFails(
      setDoc(doc(db, path), validUserPreference(OWNER_UID, {
        extractionPromptOverride: 'x'.repeat(20001),
      })),
    );
    await assertFails(
      setDoc(doc(db, path), validUserPreference(OWNER_UID, {
        extractionSystemPromptOverride: 'x'.repeat(20001),
      })),
    );
    await assertFails(
      setDoc(doc(db, path), validUserPreference(OWNER_UID, {
        chatSystemPromptOverride: '',
      })),
    );
    await assertFails(
      setDoc(doc(db, path), validUserPreference(OWNER_UID, {
        debugModeEnabled: 'yes',
      })),
    );
    await assertFails(
      setDoc(doc(db, path), withoutField(validUserPreference(OWNER_UID), 'debugModeEnabled')),
    );
    await assertFails(updateDoc(doc(db, path), { createdAt: LATER_AT, updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { userId: OTHER_UID, updatedAt: LATER_AT }));
  });
});

describe('ai_processing_consents', () => {
  const path = aiProcessingConsentPath(OWNER_UID);

  it('denies unauthenticated read and write', async () => {
    await seed(path, validAiProcessingConsent(OWNER_UID));
    const db = unauthenticatedDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(setDoc(doc(db, path), validAiProcessingConsent(OWNER_UID)));
  });

  it("denies another signed-in user touching the owner's consent", async () => {
    await seed(path, validAiProcessingConsent(OWNER_UID));
    const db = otherDb();
    await assertFails(getDoc(doc(db, path)));
    await assertFails(updateDoc(doc(db, path), { status: 'declined', updatedAt: LATER_AT }));
    await assertFails(deleteDoc(doc(db, path)));
  });

  it('allows the owner to grant, decline and tombstone consent', async () => {
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validAiProcessingConsent(OWNER_UID)));
    await assertSucceeds(getDoc(doc(db, path)));
    await assertSucceeds(updateDoc(doc(db, path), { status: 'declined', updatedAt: LATER_AT }));
    await assertSucceeds(updateDoc(doc(db, path), { isDeleted: true, updatedAt: LATER_AT }));
  });

  it('denies invalid status values and unknown fields', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validAiProcessingConsent(OWNER_UID, { status: 'maybe' })),
    );
    await assertFails(
      setDoc(doc(db, path), validAiProcessingConsent(OWNER_UID, { syncStatus: 1 })),
    );
    await assertFails(
      setDoc(doc(db, path), withoutField(validAiProcessingConsent(OWNER_UID), 'status')),
    );
  });
});

describe('extraction_runs', () => {
  const path = extractionRunPath(OWNER_UID);

  it('allows the owner to create, read, and delete', async () => {
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validExtractionRun(OWNER_UID)));
    const snapshot = await assertSucceeds(getDoc(doc(db, path)));
    assert.equal(snapshot.data().status, 'success');
    await assertSucceeds(deleteDoc(doc(db, path)));
  });

  it('denies unauthenticated and anonymous access', async () => {
    await seed(path, validExtractionRun(OWNER_UID));
    await assertFails(getDoc(doc(unauthenticatedDb(), path)));
    await assertFails(getDoc(doc(anonymousDb(), path)));
  });

  it("denies another user reading the owner's runs", async () => {
    await seed(path, validExtractionRun(OWNER_UID));
    await assertFails(getDoc(doc(otherDb(), path)));
  });

  it('allows nullable optional fields', async () => {
    const db = ownerDb();
    await assertSucceeds(
      setDoc(
        doc(db, path),
        validExtractionRun(OWNER_UID, {
          sourceConversationId: null,
          sourceConversationTitle: null,
          modelDisplayName: null,
        }),
      ),
    );
  });

  it('denies updates to immutable run history fields', async () => {
    await seed(path, validExtractionRun(OWNER_UID));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { status: 'failure' }));
    await assertFails(updateDoc(doc(db, path), { durationMs: 9999 }));
    await assertFails(updateDoc(doc(db, path), { kindCountsJson: '{"decision":10}' }));
  });

  it('allows tombstone and updatedAt changes only', async () => {
    await seed(path, validExtractionRun(OWNER_UID));
    const db = ownerDb();
    await assertSucceeds(updateDoc(doc(db, path), { isDeleted: true, updatedAt: LATER_AT }));
  });

  it('denies unknown fields, including id and syncStatus', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { id: 'run-1' })));
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { syncStatus: 0 })));
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { extra: 'field' })));
  });

  it('denies missing required fields', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), withoutField(validExtractionRun(OWNER_UID), 'modelId')));
    await assertFails(setDoc(doc(db, path), withoutField(validExtractionRun(OWNER_UID), 'startedAt')));
    await assertFails(setDoc(doc(db, path), withoutField(validExtractionRun(OWNER_UID), 'status')));
  });

  it('denies invalid status values', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { status: 'pending' })));
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { status: 'running' })));
  });

  it('denies negative or excessive durationMs', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { durationMs: -1 })));
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { durationMs: 86400001 })));
  });

  it('denies negative or excessive finding counts', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { kindCountsJson: '' })));
    await assertFails(setDoc(doc(db, path), validExtractionRun(OWNER_UID, { pendingCount: 10001 })));
  });

  it('denies inverted timestamps', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validExtractionRun(OWNER_UID, { startedAt: LATER_AT, completedAt: CREATED_AT })),
    );
  });

  it('denies userId mismatch with path', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, path), validExtractionRun(OTHER_UID)));
  });
});

describe('extraction_item_kinds', () => {
  const path = extractionItemKindPath(OWNER_UID, 'groceries');

  it('allows the owner to create a groceries kind', async () => {
    const db = ownerDb();
    await assertSucceeds(setDoc(doc(db, path), validExtractionItemKind(OWNER_UID)));
    const snapshot = await assertSucceeds(getDoc(doc(db, path)));
    assert.equal(snapshot.data().slug, 'groceries');
  });

  it('denies unauthenticated and other-user access', async () => {
    await seed(path, validExtractionItemKind(OWNER_UID));
    await assertFails(getDoc(doc(unauthenticatedDb(), path)));
    await assertFails(getDoc(doc(otherDb(), path)));
  });

  it('denies invalid slugs, overlong displayName, and unknown fields', async () => {
    const db = ownerDb();
    await assertFails(
      setDoc(doc(db, path), validExtractionItemKind(OWNER_UID, { slug: 'Decision' })),
    );
    await assertFails(
      setDoc(doc(db, path), validExtractionItemKind(OWNER_UID, { slug: 'my kind' })),
    );
    await assertFails(
      setDoc(doc(db, path), validExtractionItemKind(OWNER_UID, { displayName: 'x'.repeat(81) })),
    );
    await assertFails(setDoc(doc(db, path), validExtractionItemKind(OWNER_UID, { id: 'kind-1' })));
    await assertFails(
      setDoc(doc(db, path), validExtractionItemKind(OWNER_UID, { syncStatus: 0 })),
    );
  });

  it('denies mutating slug or isBuiltIn', async () => {
    await seed(path, validExtractionItemKind(OWNER_UID));
    const db = ownerDb();
    await assertFails(updateDoc(doc(db, path), { slug: 'shopping', updatedAt: LATER_AT }));
    await assertFails(updateDoc(doc(db, path), { isBuiltIn: true, updatedAt: LATER_AT }));
  });
});

describe('everything else', () => {
  it('denies unknown collections at the root and under the user', async () => {
    const db = ownerDb();
    await assertFails(setDoc(doc(db, 'meeting_notes/note-1'), { title: 'x' }));
    await assertFails(setDoc(doc(db, `users/${OWNER_UID}/meeting_notes/note-1`), { title: 'x' }));
    await assertFails(setDoc(doc(db, `users/${OWNER_UID}/entitlements/current`), { plan: 'pro' }));
    await assertFails(getDoc(doc(db, `users/${OWNER_UID}/entitlements/current`)));
  });

  it('denies collection-group queries that would escape the uid prefix', async () => {
    await seed(evidencePath(OWNER_UID), validEvidence());
    const db = ownerDb();
    await assertFails(getDocs(collectionGroup(db, 'evidence')));
    await assertFails(getDocs(collectionGroup(db, 'source_conversations')));
    await assertFails(getDocs(collectionGroup(db, 'extraction_runs')));
    await assertFails(getDocs(collectionGroup(db, 'chat_messages')));
  });
});
