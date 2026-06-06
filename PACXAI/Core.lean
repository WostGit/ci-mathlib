namespace PACXAI

/-- A finite transcript-derived artifact is represented by an observation function. -/
abbrev Observation (Secret Output : Type) := Secret -> Output

/-- A reconstruction criterion says whether a guess successfully recovers the protected feature. -/
abbrev Criterion (Secret Guess : Type) := Secret -> Guess -> Bool

/-- Count successful reconstructions over a finite population. -/
def successCount {Secret Guess : Type} (secrets : List Secret) (criterion : Criterion Secret Guess) (attack : Secret -> Guess) : Nat :=
  (secrets.filter (fun s => criterion s (attack s))).length

/-- Deterministic post-processing of an observation. -/
def postprocess {Secret Raw Out : Type} (obs : Observation Secret Raw) (f : Raw -> Out) : Observation Secret Out :=
  fun s => f (obs s)

/-- Any attack on a post-processed observation is simulated by an attack on the raw observation. -/
def liftedAttack {Raw Out Guess : Type} (f : Raw -> Out) (attack : Out -> Guess) : Raw -> Guess :=
  fun r => attack (f r)

/-- Pointwise equality behind the transcript-to-student reduction. -/
theorem postprocess_attack_pointwise {Secret Raw Out Guess : Type}
    (obs : Observation Secret Raw) (f : Raw -> Out) (attack : Out -> Guess) (s : Secret) :
    attack ((postprocess obs f) s) = (liftedAttack f attack) (obs s) := by
  rfl

/-- Empirical success is exactly preserved by the lifted transcript-level simulator. -/
theorem postprocess_successCount_eq {Secret Raw Out Guess : Type}
    (secrets : List Secret) (criterion : Criterion Secret Guess)
    (obs : Observation Secret Raw) (f : Raw -> Out) (attack : Out -> Guess) :
    successCount secrets criterion (fun s => attack ((postprocess obs f) s)) =
    successCount secrets criterion (fun s => (liftedAttack f attack) (obs s)) := by
  rfl

/-- A compact theorem statement for CI and paper-facing artifact checks. -/
theorem distilled_student_attack_is_transcript_attack
    {Secret Transcript Student Guess : Type}
    (secrets : List Secret)
    (criterion : Criterion Secret Guess)
    (transcript : Observation Secret Transcript)
    (train : Transcript -> Student)
    (studentAttack : Student -> Guess) :
    successCount secrets criterion (fun s => studentAttack (train (transcript s))) =
    successCount secrets criterion (fun s => (fun t => studentAttack (train t)) (transcript s)) := by
  rfl

end PACXAI
