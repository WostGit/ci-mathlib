# Threat Model

## System boundary

The system exposes a model or service through API interactions. An adversary may issue adaptive queries, receive answers, and collect explanations or traces when available.

The audited object is the transcript:

```text
Transcript = all data that the audit claims is available to the student-training process
```

A transcript may contain:

- prompts;
- model outputs;
- explanations;
- tool traces;
- timestamps or account metadata if those are intentionally included;
- any public side information included in the audit boundary.

## Secret

The secret is the protected feature the defender does not want recovered.

Examples:

- hidden capability label;
- protected prompt family;
- proprietary behavior class;
- sensitive training-source category;
- internal policy or tool-use behavior;
- user or subgroup attribute.

The Lean code leaves `Secret` abstract so the theorem applies to many concrete audit designs.

## Adversary

The adversary sees a transcript-derived artifact, such as:

- a distilled student model;
- a classifier trained from transcripts;
- a dashboard;
- an explanation summary;
- an extracted rule table;
- a feature matrix.

The adversary outputs a guess. A recovery criterion decides whether the guess succeeds.

## Main assumption

The core theorem assumes the artifact is deterministic post-processing of the audited transcript:

```text
student = train(transcript)
```

This is not a harmless assumption. It is the central proof obligation.

## Out of scope unless included in the transcript

The theorem does not automatically cover training that uses:

- private external corpora;
- hidden labels;
- human feedback;
- secret-correlated account metadata;
- unlogged prompts;
- hidden chain-of-thought traces;
- reinforcement learning signals;
- pretrained weights containing the same secret.

To make the theorem apply, those sources must either be included in the audited transcript or handled by a separate assumption/theorem.

## Security claim supported by the artifact

For finite recovery audits:

> If a transcript-derived artifact is deterministic post-processing of the audited transcript, then every finite recovery attack on the artifact has an equivalent transcript-level simulator with exactly the same empirical success count.

## Security claim not supported by the artifact

The artifact does not prove that a real-world model training pipeline is deterministic post-processing. That is a modeling obligation for the system designer or auditor.

The artifact also does not prove Shannon mutual-information bounds, Gaussian privacy accounting, or rate-distortion lower bounds.
