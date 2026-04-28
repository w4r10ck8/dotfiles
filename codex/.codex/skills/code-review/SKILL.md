---
name: code-review
description: Review code changes for bugs, regressions, risky assumptions, and missing tests. Use when Codex is asked to review a pull request, diff, commit, patch, feature branch, refactor, or implementation before merge, especially when the goal is to surface actionable findings first rather than summarize the change.
---

# Code Review

## Overview

Review for correctness and operational risk first. Optimize for catching what would break behavior, ship a regression, or leave the change under-tested.

## Review Priorities

Inspect in this order:

- Functional bugs and correctness issues
- Behavioral regressions relative to the prior code path
- Security, data-loss, concurrency, or migration risk
- Missing validation, error handling, or edge-case coverage
- Missing or weak tests for high-risk changes
- Maintainability issues only when they create clear delivery or support risk

Do not lead with style nits, naming preferences, or low-signal cleanup unless the user explicitly asks for that level of review.

## Review Workflow

1. Build context before judging details.
Read the diff, then inspect surrounding code, touched interfaces, and any tests that should prove the behavior.

2. Infer intended behavior from code, tests, and nearby call sites.
If the change goal is unclear, say so and frame findings around the most likely interpretation.

3. Pressure-test the change.
Look for broken invariants, mismatched types, stale assumptions, partial refactors, missing updates to callers, and state transitions that are no longer safe.

4. Check the proving surface.
Verify whether tests cover the risky paths, not just the happy path. Call out when the implementation may be correct but insufficiently proven.

5. Report only findings that are actionable and defensible.
Each finding should explain what is wrong, why it matters, and the condition under which it fails.

## Output Format

Present findings first, ordered by severity.

For each finding:

- Start with the impact in one sentence
- Reference the file and line when available
- Explain the failure mode or regression clearly
- Keep proposed fixes short unless the user asks for a patch

If there are no findings, say that explicitly. After findings, include brief residual risks or testing gaps if they matter.

Keep summaries short. Do not bury findings under a long overview.

## Review Heuristics

- Prefer concrete breakage over hypothetical concerns
- Favor issues with user-visible impact, deploy risk, or maintenance traps
- Check unchanged callers and downstream consumers when interfaces move
- Check config, migrations, feature flags, and background jobs when behavior spans files
- Treat deleted tests or narrowed assertions as a signal to investigate
- Treat missing rollback or failure-path handling as high signal for infra and data changes

## Anti-Patterns

- Do not restate the diff without analysis
- Do not flood the review with minor style comments
- Do not speculate about issues you cannot connect to the code
- Do not ask for tests mechanically; tie the request to a concrete risk
- Do not miss a likely regression because the new code looks cleaner than the old code

## Example Triggers

- "Review this PR"
- "Look over this diff for regressions"
- "Do a code review on my branch"
- "Find bugs in this refactor before I merge it"
- "Check whether this patch is safe"
