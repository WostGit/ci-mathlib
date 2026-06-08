# Artifact Evaluation README

## Claims checked by CI

The GitHub Actions workflow checks three things:

1. The Lean project builds with `lake build`.
2. The audit script finds no forbidden proof tokens such as `sorry`, `admit`, `axiom`, `constant`, `unsafe`, or `opaque`.
3. The main theorem reports no axioms via `#print axioms`.

## How to reproduce locally

```bash
lake build
bash scripts/audit.sh
python3 experiments/run_distillation_audit.py
```

## Expected Lean result

The build should compile the full tree:

```text
PACXAI.Core
PACXAI.Transcript
PACXAI.Recovery
PACXAI.Conditioning
PACXAI.Distillation
PACXAI.Leakage.FiniteCapacity
PACXAI
```

## Expected audit result

The audit should print that no forbidden tokens are found and that the checked theorems do not depend on axioms.

## Expected experiment result

The experiment should show:

```text
deterministic_student_minus_transcript_simulator_success = 0
auxiliary_student_minus_transcript_simulator_success > 0
```

The first line means the theorem's post-processing condition is satisfied. The second line demonstrates the assumption bug when auxiliary secret-correlated data is used.

## What counts as artifact success?

A successful artifact evaluation should verify:

- clean build;
- no proof holes;
- no unproved axioms for the main theorems;
- regenerated case-study outputs;
- readable documentation explaining what is and is not claimed.
