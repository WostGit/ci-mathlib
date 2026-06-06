#!/usr/bin/env bash
set -euo pipefail

echo "[audit] forbidden token scan"
if grep -RIn --include='*.lean' \
  -e '\bsorry\b' -e '\badmit\b' -e '\baxiom\b' -e '\bconstant\b' \
  -e '\bunsafe\b' -e '\bopaque\b' -e 'TODO' -e 'FIXME' \
  PACXAI PACXAI.lean lakefile.lean; then
  echo "Forbidden token found" >&2
  exit 1
else
  echo "No forbidden tokens found"
fi

echo "[audit] theorem check"
cat > /tmp/PACXAIPrint.lean <<'EOF'
import PACXAI
#print axioms PACXAI.postprocess_successCount_eq
#print axioms PACXAI.distilled_student_attack_is_transcript_attack
EOF
lake env lean /tmp/PACXAIPrint.lean
