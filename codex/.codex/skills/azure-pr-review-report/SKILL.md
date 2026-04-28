---
name: azure-pr-review-report
description: Review Azure DevOps pull requests and generate a local Markdown report file named `PR-<number>-review.md`. Use when the user asks to review an Azure PR by number, compare the changed files against the target branch, and produce file-level review notes with line numbers for later posting into Azure DevOps.
---

# Azure PR Review Report

Review Azure DevOps PRs into a local Markdown artifact instead of posting comments directly into the PR.

## Workflow

1. Resolve PR context first.
Run `scripts/resolve-pr-context.sh <pr-number>` from the repo root. Prefer Azure DevOps metadata when available. Fall back to the current local branch only when Azure lookup is unavailable.

2. Confirm the comparison base.
Review the source branch against the PR target branch. Do not review only the working tree without checking the target branch context.

3. Limit the review to changed files.
Use the resolved diff range and changed-file list. Inspect surrounding code and tests for each changed file before writing findings.

4. Apply `$code-review`.
Focus on bugs, regressions, risky assumptions, and missing tests. Keep broad commentary short.

5. Write or overwrite `.reviews/PR-<number>-review.md`.
Create the `.reviews/` directory when needed. Overwrite the report on reruns so there is one current file per PR.

## Report Format

Use this structure:

```md
# PR-<number> Review

## Metadata
- PR: <number>
- Title: <title or unknown>
- Repo: <repo name>
- Source: <source branch>
- Target: <target branch>
- Mode: <azure|local fallback>
- Generated: <timestamp>

## General Notes
- Short, high-level observations only

## Findings

### Critical
- None

### High
- [path/to/file.ext:123] Short issue title
  Risk and reasoning in 1-3 concise sentences.

### Medium
- ...

### Low
- ...

## Residual Risks / Test Gaps
- Only include if they materially matter
```

## Rules

- Keep `General Notes` brief. Do not bury file-level feedback there.
- Put file-level findings under severity sections with file path and line number.
- Use the closest defensible line number when the exact diff line is unstable.
- If there are no actionable findings, still generate the file and state that clearly.
- Do not commit the report file.
- Do not post findings to Azure DevOps unless the user explicitly asks.

## Resources

### scripts/

- `scripts/resolve-pr-context.sh <pr-number>`
  Resolve PR title, source branch, target branch, repo root, review file path, and changed files.
