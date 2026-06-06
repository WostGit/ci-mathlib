import Lake
open Lake DSL

package «pacxai_ci_mathlib» where
  -- Mathlib-free core artifact used by the CI workflow.

@[default_target]
lean_lib PACXAI where
  roots := #[`PACXAI]
