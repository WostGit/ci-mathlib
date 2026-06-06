#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
from pathlib import Path

CAPABILITIES = ["reasoning", "coding", "tool_use", "computer_use"]
GROUPS = ["normal", "proxy_cluster", "fraudulent"]


def population(n: int = 120):
    rows = []
    for i in range(n):
        group = GROUPS[i % len(GROUPS)]
        cap = CAPABILITIES[(i * 7 + (2 if group == "fraudulent" else 0)) % len(CAPABILITIES)]
        rows.append({"sid": i, "group": group, "capability": cap})
    return rows


def transcript(s):
    if s["group"] == "fraudulent":
        requested = s["capability"]
    else:
        requested = "masked"
    if s["capability"] in {"coding", "tool_use", "computer_use"}:
        sig = "agentic"
    else:
        sig = "reasoning"
    return {"requested": requested, "signature": sig, "group": s["group"]}


def train(t):
    if t["requested"] != "masked":
        return t["requested"]
    return "coding" if t["signature"] == "agentic" else "reasoning"


def train_with_aux(s, t):
    if s["group"] in {"fraudulent", "proxy_cluster"}:
        return s["capability"]
    return train(t)


def success(pop, attack):
    return sum(1 for s in pop if attack(s) == s["capability"])


def main():
    pop = population()
    det_student = lambda s: train(transcript(s))
    transcript_sim = lambda s: train(transcript(s))
    aux_student = lambda s: train_with_aux(s, transcript(s))

    rows = []
    for scope, subset in [("all", pop)] + [(f"group={g}", [s for s in pop if s["group"] == g]) for g in GROUPS]:
        for name, attack in [("deterministic_student", det_student), ("transcript_simulator", transcript_sim), ("auxiliary_student", aux_student)]:
            c = success(subset, attack)
            rows.append({"scope": scope, "attack": name, "success": c, "total": len(subset), "rate": c / len(subset) if subset else 0})

    out = Path("results")
    out.mkdir(exist_ok=True)
    with (out / "audit_results.csv").open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["scope", "attack", "success", "total", "rate"])
        w.writeheader(); w.writerows(rows)
    by = {(r["scope"], r["attack"]): r for r in rows}
    summary = {
        "population_size": len(pop),
        "deterministic_student_minus_transcript_simulator_success": by[("all", "deterministic_student")]["success"] - by[("all", "transcript_simulator")]["success"],
        "auxiliary_student_minus_transcript_simulator_success": by[("all", "auxiliary_student")]["success"] - by[("all", "transcript_simulator")]["success"],
    }
    (out / "audit_summary.json").write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
