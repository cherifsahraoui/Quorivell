# Firebase Security Rules tests

Emulator-based tests for `firestore.rules` and `storage.rules` at the repo root.

This directory is a standalone Node package on purpose: it keeps `node_modules`
and the JavaScript toolchain out of the Flutter build, `dart format`,
`flutter analyze`, and `flutter test`.

## Run

```bash
cd firebase/test
npm install
npm test
```

`npm test` starts the Auth, Firestore, and Storage emulators via
`firebase-tools`, runs the suite with the Node test runner, and shuts the
emulators down again. It uses the emulator-only project id
`demo-quorivell-rules`; the `demo-` prefix means no real Firebase project,
credentials, or network access is involved. Nothing is ever deployed.

If the emulators are already running (`npx -y firebase-tools@latest
emulators:start --project demo-quorivell-rules --only auth,firestore,storage`),
run the suite alone with:

```bash
npm run test:no-emulator
```

## Requirements

- Node 18 or newer (uses `node --test` and ES modules).
- **A JDK 21 or newer on `PATH`.** Current `firebase-tools` refuses to start
  the emulators on older runtimes with
  `firebase-tools no longer supports Java version before 21`. On a machine
  with Android Studio installed, its bundled runtime works:

  ```powershell
  $env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
  $env:PATH = "$env:JAVA_HOME\bin;" + $env:PATH
  ```

## Conventions

- Fixtures live in `support/harness.mjs` and are entirely synthetic. Never put
  real conversation content, evidence, prompts, credentials, or secrets here.
- Every collection is covered for: unauthenticated access, cross-user access,
  the owner happy path, malformed and extra-field payloads, and attempts to
  mutate immutable fields.
- A denied update is reported by the Firestore emulator as
  `evaluation error at L<n>` rather than `false`. That is the emulator's
  wording for a failed update rule, not a bug in the rules.
