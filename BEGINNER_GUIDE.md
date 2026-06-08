# Beginner Guide: What This Repository Proves

This guide is for readers who know programming but do not know formal proofs.

## 1. The everyday idea

Suppose an attacker collects many API conversations with a powerful model. Later, the attacker trains a smaller student model from those conversations.

The pipeline is:

```text
secret capability -> API transcript -> training -> student artifact -> attacker guess
```

The privacy question is:

> If the student leaks a secret capability, did the transcript already leak it?

This repository proves a precise finite answer:

> Yes, if the student is only a deterministic function of the transcript.

## 2. What does deterministic mean?

Deterministic means the training step has this shape:

```text
train : Transcript -> Student
```

The only input to training is the transcript.

If the real training step has this shape instead:

```text
train : Transcript -> AuxiliaryData -> Student
```

then the theorem does not apply unless the auxiliary data is included in the audited transcript or separately justified.

This is the most important assumption in the whole artifact.

## 3. What is a recovery criterion?

A recovery criterion is a yes/no test saying whether the attack guessed correctly.

Examples:

```text
Did the attacker recover the hidden capability label?
Did the attacker identify the protected prompt family?
Did the attacker reconstruct the secret class?
Did the attacker exceed the allowed recovery threshold?
```

In Lean this is a function:

```lean
Criterion Secret Guess := Secret -> Guess -> Bool
```

Given a secret and a guess, it returns true or false.

## 4. What does success count mean?

The audit uses a finite population, for example 120 test cases.

For each test case, the attacker makes a guess. The success count is just the number of correct guesses.

No probability theory is needed for this core result. It is finite counting.

## 5. What does the main theorem say?

Suppose:

```text
T(secret) = transcript generated from the secret
train(transcript) = student artifact
A(student) = attacker's guess
```

Then the student attack is:

```text
A(train(T(secret)))
```

But a transcript-level simulator can do the same thing:

```text
sim(transcript) = A(train(transcript))
```

So on every secret:

```text
student attack result = transcript simulator result
```

Therefore the number of successes is exactly the same.

That is the core theorem.

## 6. Why is this useful?

It turns a vague sentence into a checkable condition.

Vague sentence:

> The student is just post-processing, so it cannot leak more.

Formal obligation:

> Provide an actual deterministic function `train : Transcript -> Student` and show all data used by training is inside `Transcript`.

If you cannot do that, the privacy argument is incomplete.

## 7. What the Python case study shows

The experiment creates synthetic audit cases.

Case 1: deterministic student.

```text
student = train(transcript)
```

Result: student success minus transcript-simulator success is 0.

Case 2: auxiliary-data student.

```text
student = train(transcript, auxiliary secret-correlated data)
```

Result: the auxiliary-data student gets extra successes. This shows the post-processing proof no longer applies.

## 8. What does "no axioms" mean?

Lean can sometimes accept a theorem if you assume something as an axiom. This project audits the main theorems with `#print axioms`.

When the log says:

```text
PACXAI.student_attack_lifts_to_transcript does not depend on any axioms
```

that means Lean checked the theorem directly from definitions, not from an unproved assumption.

## 9. What this is not

This is not a full formalization of mutual information, Gaussian entropy, or rate-distortion theory.

It is a finite recovery audit framework. That is narrower, but it is clean, checkable, and directly relevant to transcript-derived artifacts.
