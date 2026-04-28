#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('transcript_path',''))")
SESSION_ID=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('session_id','unknown'))")
CWD=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd','unknown'))")

[[ -z "$TRANSCRIPT_PATH" || ! -f "$TRANSCRIPT_PATH" ]] && exit 0

LOG_DIR="$HOME/.claude/logs/compactions"
mkdir -p "$LOG_DIR"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
PROJECT=$(basename "$CWD")
OUTPUT="$LOG_DIR/${DATE}_${PROJECT}.md"

python3 << PYEOF
import json, sys

transcript = "$TRANSCRIPT_PATH"
output = "$OUTPUT"
session = "$SESSION_ID"
project = "$PROJECT"
date = "$DATE"

lines = []
try:
    with open(transcript) as f:
        lines = [json.loads(l) for l in f if l.strip()]
except Exception:
    sys.exit(0)

md = [
    "# Compaction Log", "",
    f"**Session:** {session}  ",
    f"**Project:** {project}  ",
    f"**Date:** {date}  ",
    "**Trigger:** PreCompact",
    "", "---", ""
]

for entry in lines:
    msg = entry.get("message", entry)
    role = msg.get("role") or entry.get("type", "unknown")
    if role not in ("user", "assistant"):
        continue
    content = msg.get("content", "")
    if isinstance(content, list):
        parts = []
        for block in content:
            if isinstance(block, dict):
                if block.get("type") == "text":
                    parts.append(block.get("text", ""))
                elif block.get("type") == "tool_use":
                    parts.append(f"[Tool: {block.get('name','')}]")
                elif block.get("type") == "tool_result":
                    parts.append("[Tool result]")
            elif isinstance(block, str):
                parts.append(block)
        content = "\n".join(p for p in parts if p)
    if not content:
        continue
    label = "## User" if role == "user" else "## Assistant"
    md += [label, "", str(content).strip(), "", "---", ""]

with open(output, "w") as f:
    f.write("\n".join(md))
PYEOF
