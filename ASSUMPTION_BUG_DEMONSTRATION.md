# Assumption Bug Demonstration

## The informal argument

A common privacy argument says:

> The student model was trained from the transcript, so it is only post-processing. Therefore it cannot reveal more than the transcript.

This is correct only if the real training process has exactly this type:

```text
train : Transcript -> Student
```

## The bug

Many realistic pipelines actually have this type:

```text
train : Transcript -> AuxiliaryData -> Student
```

or:

```text
train : Transcript -> PretrainedModel -> HumanFeedback -> Metadata -> Student
```

In that case, the student is not merely post-processing of the audited transcript.

## Why Lean catches this

The Lean theorem requires the function:

```lean
train : Transcript -> Student
```

If your system needs extra inputs, you cannot instantiate the theorem honestly.

You must either:

1. expand `Transcript` so it includes all extra inputs;
2. prove the extra inputs are independent or irrelevant using a separate theorem;
3. weaken the claim;
4. admit the audit boundary was incomplete.

## Synthetic case study

The Python experiment implements two cases.

### Case 1: sound deterministic post-processing

```text
student = train(transcript)
```

The student attack and transcript simulator have the same success count.

### Case 2: auxiliary data bug

```text
student = train(transcript, auxiliary secret-correlated data)
```

The student gets additional successes that the transcript simulator cannot match.

That is not a contradiction of the theorem. It is the theorem correctly refusing to apply to an invalid model.

## S&P paper message

The publishable security lesson is:

> Artifact-level privacy audits are sound only after proving the artifact is deterministic post-processing of the audited boundary. Lean turns this hidden assumption into an explicit type obligation.
