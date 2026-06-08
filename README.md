# PACXAI: Lean-Checked Transcript Privacy Audits

This repository contains a small, reproducible Lean artifact for reasoning about privacy audits of transcript-derived artifacts such as distilled student models, summaries, dashboards, explanation logs, or classifiers.

The main security lesson is simple:

> If a student artifact is a deterministic function of the audited transcript, then every attack on the student can be simulated as an attack on the transcript. If the student uses extra auxiliary data, this theorem no longer applies.

You do **not** need to know Lean or proof theory to understand the project. Think of Lean as a very strict proof checker. If Lean accepts a theorem and `#print axioms` says it has no axioms, then the theorem was checked from the definitions in the repository and Lean's trusted kernel.

## What problem does this model?

Many AI privacy arguments informally look like this:

```text
API queries -> transcript -> training/distillation -> student model -> attacker
```

A common argument says: the student is only post-processing of the transcript, so auditing the transcript is enough.

This repository makes that statement precise. It asks:

1. What exactly is the transcript?
2. What exactly is the student artifact?
3. Is the student really a deterministic function of the transcript?
4. What is the recovery criterion?
5. Which finite population or subgroup are we auditing?
6. Which candidate attacks are allowed?

If the student uses hidden auxiliary data, secret-correlated metadata, external corpora, human feedback, or private priors that were not included in the audited transcript, then the key theorem's type no longer matches the real system. That is the assumption bug.

## Main checked theorem in plain English

Lean theorem:

```lean
student_attack_lifts_to_transcript
```

Plain English:

> Given a transcript function `T`, a deterministic training function `train`, and a student-level attack `A`, the attack `A(train(T(secret)))` has exactly the same finite success count as the transcript-level simulator `fun t => A(train(t))` applied to `T(secret)`.

So if a student attack succeeds, then the transcript plus the training function already contains enough information to make the same attack succeed.

## What is currently formalized?

The repository formalizes a finite, mathlib-free audit framework:

- finite audit populations;
- reconstruction criteria;
- empirical success and failure counts;
- count-based success rates;
- deterministic post-processing;
- transcript-to-student distillation;
- candidate attack classes;
- candidate-best success over a finite adversary list;
- subgroup/conditioned audits;
- adaptive transcript structure;
- finite output-cover leakage helpers.

## What is not claimed?

This project does **not** claim to formalize full Shannon information theory or Gaussian rate-distortion. It intentionally avoids unsupported overclaims.

Not formalized here:

- Shannon entropy;
- KL divergence;
- conditional mutual information;
- continuous Gaussian distributions;
- Gaussian maximum entropy;
- covariance determinant inequalities;
- Gaussian rate-distortion.

Those are future mathlib-backed extensions. This repository is the finite recovery/privacy audit core.

## How to run

```bash
lake build
bash scripts/audit.sh
python3 experiments/run_distillation_audit.py
```

GitHub Actions runs the same checks and commits the latest logs to:

```text
ci-results/latest/
```

## Repository map

```text
PACXAI/Core.lean                      finite populations, criteria, success counts, post-processing
PACXAI/Transcript.lean                adaptive transcript structure
PACXAI/Recovery.lean                  candidate attacks and candidate-best success
PACXAI/Conditioning.lean              subgroup/campaign conditioning
PACXAI/Distillation.lean              transcript-to-student theorems
PACXAI/Leakage/FiniteCapacity.lean    finite output-cover helpers
experiments/run_distillation_audit.py synthetic distillation audit case study
scripts/audit.sh                      forbidden-token and axiom audit
BEGINNER_GUIDE.md                     proof-free explanation
THREAT_MODEL.md                       attacker and system model
ASSUMPTION_BUG_DEMONSTRATION.md       why auxiliary data breaks the theorem
S_AND_P_POSITIONING.md                how to frame this for IEEE S&P
```

## Current S&P positioning

The strongest paper claim is not "we formalized all of information theory." The strongest claim is:

> We give a Lean-checked finite recovery framework for transcript-derived artifact audits and show that artifact-level audit soundness depends on an explicit deterministic post-processing obligation.

That is the claim this repository supports.
