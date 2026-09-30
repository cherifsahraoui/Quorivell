import { after, before, describe, it } from 'node:test';

import { assertFails } from '@firebase/rules-unit-testing';
import { getBytes, ref, uploadString } from 'firebase/storage';

import { OTHER_UID, OWNER_UID, createTestEnvironment } from './support/harness.mjs';

let env;

before(async () => {
  env = await createTestEnvironment();
});

after(async () => {
  await env?.cleanup();
});

// Cloud Storage is unused in Quorivell, so the only correct behaviour is a
// total deny. These tests exist to catch an accidental widening of
// storage.rules before it can leak private content.
const paths = [
  'anything.txt',
  `users/${OWNER_UID}/export.json`,
  `users/${OWNER_UID}/recordings/clip.m4a`,
  `users/${OTHER_UID}/export.json`,
  'public/logo.png',
];

describe('storage deny-all', () => {
  for (const path of paths) {
    it(`denies unauthenticated read and write at ${path}`, async () => {
      const storage = env.unauthenticatedContext().storage();
      await assertFails(getBytes(ref(storage, path)));
      await assertFails(uploadString(ref(storage, path), 'synthetic fixture bytes'));
    });

    it(`denies the signed-in owner read and write at ${path}`, async () => {
      const storage = env.authenticatedContext(OWNER_UID).storage();
      await assertFails(getBytes(ref(storage, path)));
      await assertFails(uploadString(ref(storage, path), 'synthetic fixture bytes'));
    });
  }
});
