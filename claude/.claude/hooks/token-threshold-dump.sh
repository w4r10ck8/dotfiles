#!/usr/bin/env bash
set -euo pipefail

# Token estimation config
MAX_TOKENS=200000
THRESHOLD_PCT=95
CHARS_PER_TOKEN=4
THRESHOLD_CHARS=$(( MAX_TOKENS * THRESHOLD_PCT / 100 * CHARS_PER_TOKEN ))

INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('transcript_path',''))")
SESSION_ID=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('session_id','unknown'))")
CWD=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd','unknown'))")

[[ -z "$TRANSCRIPT_PATH" || ! -f "$TRANSCRIPT_PATH" ]] && exit 0

LOG_DIR="$HOME/.claude/logs/compactions"
mkdir -p "$LOG_DIR"
PROJECT=$(basename "$CWD")

# Skip if a threshold dump for this session already exists from the last 5 minutes
EXISTING=$(find "$LOG_DIR" -name "*_${SESSION_ID}_threshold.md" -mmin -5 2>/dev/null | head -1)
[[ -n "$EXISTING" ]] && exit 0

python3 << PYEOF
import json, sys, os

transcript = "$TRANSCRIPT_PATH"
threshold = $THRESHOLD_CHARS
log_dir = "$LOG_DIR"
session = "$SESSION_ID"
project = "$PROJECT"

lines = []
try:
    with open(transcript) as f:
        lines = [json.loads(l) for l in f if l.strip()]
except Exception:
    sys.exit(0)

total_chars = 0
messages = []
for entry in lines:
    msg = entry.get("message", entry)
    role = msg.get("role") or entry.get("type", "unknown")
    if role not in ("user", "assistant"):
        continue
    content = msg.get("content", "")
    text = ""
    if isinstance(content, list):
        for block in content:
            if isinstance(block, dict) and block.get("type") == "text":
                text += block.get("text", "")
    elif isinstance(content, str):
        text = content
    total_chars += len(text)
    messages.append((role, text))

if total_chars < threshold:
    sys.exit(0)

from datetime import datetime
date = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
output = os.path.join(log_dir, f"{date}_{project}_{session}_threshold.md")
est_tokens = total_chars // 4
pct = round(est_tokens / 200000 * 100, 1)

md = [
    "# Token Threshold Dump", "",
    f"**Session:** {session}  ",
    f"**Project:** {project}  ",
    f"**Date:** {date}  ",
    f"**Trigger:** Token threshold ({pct}% estimated used)  ",
    f"**Estimated tokens:** ~{est_tokens:,} / 200,000",
    "", "---", ""
]

for role, text in messages:
    if not text.strip():
        continue
    label = "## User" if role == "user" else "## Assistant"
    md += [label, "", text.strip(), "", "---", ""]

with open(output, "w") as f:
    f.write("\n".join(md))
PYEOF
