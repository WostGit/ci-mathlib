# IEEE S&P Positioning

## Best title

**When Distilled Models Leak: Lean-Checked Transcript Privacy Audits**

## Strongest contribution claim

This artifact does not claim to mechanize all of information theory. Its strongest claim is narrower and sharper:

> We formalize finite recovery privacy audits for transcript-derived artifacts and prove that artifact-level recovery attacks are soundly subsumed by transcript-level attacks only under an explicit deterministic post-processing obligation.

## Why this can matter to security reviewers

Many modern AI extraction and distillation threats have this shape:

```text
adaptive API collection -> transcript corpus -> student/distilled artifact -> downstream recovery attack
```

Security audits often reason informally that the student is just post-processing of the transcript. This repository shows exactly what must be true for that sentence to be valid.

The project is useful because it converts an informal phrase into a checkable proof obligation.

## Paper structure

1. Introduction: distillation and transcript-derived artifacts.
2. Motivating bug: artifact audit assumes post-processing but training uses auxiliary data.
3. Formal model: finite population, transcript, student, recovery criterion, candidate adversaries.
4. Main theorem: student attacks lift to transcript attacks.
5. Conditioning theorem: subgroup/campaign audits cannot be hand-waved.
6. Candidate-class theorem: finite adversary suites preserve best-success under lifting.
7. Evaluation: deterministic case, auxiliary-data failure case, subgroup conditioning.
8. Limitations: not Shannon/Gaussian/rate-distortion.
9. Artifact: Lean CI, forbidden-token scan, no-axiom checks.

## What would make it stronger

For an IEEE S&P main-track submission, the current repository should be extended with:

- a larger public or semi-real transcript audit dataset;
- a richer candidate adversary suite;
- comparison to informal artifact-only audits;
- a documented real-world case where auxiliary information invalidates a post-processing claim;
- a mathlib-backed optional bridge to KL/MI/Fano, clearly separated from the finite core.

## What not to claim

Do not claim:

- full PAC Privacy mechanization;
- full mutual-information accounting;
- Gaussian maximum-entropy formalization;
- Gaussian rate-distortion formalization;
- proof that any particular real company incident happened exactly this way.

## Best honest current claim

> A Lean-checked finite recovery framework that exposes and verifies the post-processing obligation required for sound transcript-derived artifact audits.
