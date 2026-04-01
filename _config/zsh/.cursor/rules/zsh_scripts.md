---
description: Best practices for writing shell (zsh) scripts
globs: ["_config/zsh/**"]
alwaysApply: false
---
General Style
- Follow the [Google Style Guide](https://google.github.io/styleguide/shellguide.html)
- For all top-level functions, scripts -- any non- "helper" scripts/functions -- the code should be contained within a `main` function and be invoked with `main "$@"`
- Use locals inside of `main` for all variables

Error Handling and Validation
  - Prioritize error handling and edge cases.
  - Handle errors and edge cases at the beginning of functions.
  - Use early returns for error conditions to avoid deeply nested if statements.
  - Place the happy path last in the function for improved readability.
  - Avoid unnecessary else statements; use if-return pattern instead.
  - Use guard clauses to handle preconditions and invalid states early.
  - Implement proper error logging and user-friendly error messages.