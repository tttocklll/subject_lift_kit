 # Repository Guidelines

 ## Project Structure & Module Organization
 - `lib/`: Public Dart API (`subject_lift_kit.dart`).
 - `lib/gen/`: Generated Pigeon bindings; do not edit.
 - `ios/Classes/`: Swift plugin implementation (`SubjectLiftKitPlugin.swift`, `Messages.g.swift`).
 - `pigeons/`: Pigeon definitions (`messages.dart`) — edit here, then regenerate.
 - `example/`: Runnable sample app (`lib/`, `test/`), used for local dev and tests.
 - `analysis_options.yaml`: Lints via `flutter_lints`.

 ## Build, Test, and Development Commands
 - Install deps: `flutter pub get`
 - Lint: `flutter analyze`
 - Format: `dart format .`
 - Regenerate Pigeon code: `dart run pigeon --input pigeons/messages.dart`
 - Run example: `cd example && flutter run`
 - Test example: `cd example && flutter test` (tests live in `example/test`)
 - iOS build (example): `cd example && flutter build ios` (requires Xcode + device)

 ## Coding Style & Naming Conventions
 - Dart: 2‑space indent; follow `flutter_lints`. Files use `snake_case.dart`; types `UpperCamelCase`; members `lowerCamelCase`.
 - Swift: 2‑space indent; types `UpperCamelCase`; methods/properties `lowerCamelCase`.
 - Generated files: Do not edit `lib/gen/*.dart` or `ios/Classes/Messages.g.swift`. Change `pigeons/messages.dart` and regenerate.
 - Public API: Keep `SubjectLiftKit` surface minimal and documented.

 ## Testing Guidelines
 - Framework: `flutter_test` (see `example/test`). Name tests `*_test.dart`.
 - Run tests: `cd example && flutter test` (optionally `--coverage`).
 - Add tests when modifying public API or Pigeon messages. Prefer widget/integration tests in `example` demonstrating realistic flows.

 ## Commit & Pull Request Guidelines
 - Conventional Commits: use prefixes like `feat:`, `fix:`, `docs:`, `refactor:`, `chore:` (matches repo history).
 - Commits: short, imperative subject; include scope when helpful (e.g., `fix(ios): …`).
 - PRs: clear description, rationale, screenshots if UI in example changes, linked issues, and testing notes. If Pigeon changed, include regenerated files in the same PR.

 ## Security & Platform Notes
 - iOS‑only; requires iOS 17+ and a physical device (Vision API is unavailable on Simulator).
 - Avoid large binary assets in repo; prefer loading test images at runtime in the example app.
 - Do not commit credentials or provisioning profiles.

