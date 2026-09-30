# Contributing to Quorivell

Thanks for considering a contribution. Quorivell is a local-first Flutter app:
capture conversation text, extract reviewable candidates on-device, and keep an
evidence-backed ledger — without sending source content to the cloud by
default.

By participating, you agree to follow the
[Code of Conduct](CODE_OF_CONDUCT.md).

## Before you start

1. **Open an issue first** for large architectural changes, new cloud or sync
   surfaces, or anything that would change the privacy boundary.
2. Prefer small, focused pull requests over wide refactors mixed with
   behavior changes.
3. Skim [docs/architecture.md](docs/architecture.md) and
   [docs/data-structures.md](docs/data-structures.md) so PRs match the existing
   stack and local/Firestore mirror contract.

## Development setup

Follow **Build from source** in the [README](README.md):

```bash
git clone https://github.com/cherifsahraoui/Quorivell.git
cd Quorivell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Firebase client config is not shipped. Local capture and on-device AI work
without it. Use `flutterfire configure` only if you need Auth / App Check
against your own project.

On first launch you still need a verified or imported GGUF before capture and
extract unlock.

## Project conventions (short)

| Area | Expectation |
| --- | --- |
| Layout | Feature-first under `lib/features/<feature>/{data,domain,presentation}` |
| State / DI | Riverpod with `@riverpod` / `riverpod_generator` |
| Persistence | Drift is canonical; do not invent a second store |
| Models | Freezed + json_serializable for domain entities and DTOs |
| UI copy | EN / DE / AR together via `lib/l10n/*.arb`, then `flutter gen-l10n` |
| Generated | Never hand-edit `*.g.dart`, `*.freezed.dart`, or `lib/l10n/app_localizations*.dart` |
| Privacy | No real conversation content, credentials, or secrets in tests or samples |

Keep business logic out of widgets. Presentation depends on domain interfaces;
data implements them. Do not import Firebase SDKs from UI or domain layers.

## Tests and checks

For the paths you touch:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test <relevant paths>
```

- Changed repository, data source, controller, or model adapter → unit tests
- Changed page, sheet, dialog, or shared widget → widget tests (loading /
  empty / error / data where applicable)
- After Freezed / Riverpod / Drift / JSON annotation changes →
  `dart run build_runner build --delete-conflicting-outputs`

## Pull requests

1. Fork (or branch), implement, and keep the diff reviewable.
2. Describe **what** changed and **how to verify** it.
3. Link related issues.
4. Confirm locales stay in sync if you changed user-facing strings.
5. Do not commit model weights (`.gguf`), secrets, or Play signing material.

## Reporting bugs

Use [GitHub Issues](https://github.com/cherifsahraoui/Quorivell/issues). Include
Flutter/Dart versions, platform, steps to reproduce, and expected vs actual
behavior. Redact any personal or conversation content.

Security vulnerabilities: see [SECURITY.md](SECURITY.md) — do not file them as
public issues.

## License

Contributions are accepted under the [MIT License](LICENSE).
