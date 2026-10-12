# Coding conventions

- Always use a braced code block for every `if` body, even when it contains only one statement. Never write `if (condition) doSomething();` on one line or leave the body unbraced on the following line.
- Apply the same braced block convention to `else` bodies.
- Do not use ternary expressions (`condition ? value : otherValue`). Use braced `if`/`else` blocks or a `switch` instead.
- Use blank lines to separate logical sections by code context. In particular, leave a blank line after a guard clause or validation block before the normal execution path or success return. Keep closely related declarations together; do not add blank lines between every statement.
- Never create tests unless the user explicitly asks for them. Do not add tests automatically as part of implementation, fixes, refactoring, or validation.
- Each public feature screen owns its `ChangeNotifierProvider`, creates its state, and wraps a private widget containing the actual UI (for example, `LoginScreen` wraps `_LoginScreen`). Routes construct the public screen without declaring its provider.
- Do not add documentation comments to screens. Keep form controllers in the feature state and use a stateless private screen with a `Consumer` for that state.

# Current refactor scope

- Work on the `auth`, `user`, `settings`, `trip`, `person`, `stop`, and `search` modules, their new feature screens, `AppState`, and initialization wiring.
- Do not use legacy use cases or add compatibility adapters for old modules or screens in this refactor. Keep old modules separate from their new replacements.
- Leave legacy modules and existing presentation screens unchanged unless the user explicitly requests changes to them. Home, map, routes, and session navigation are included in the current refactor. Remove obsolete legacy code only after its replacement is wired in.

