---
name: codex-log
description: Log work to the Codex Obsidian vault. Use when Jay wants to record a ticket update, investigation finding, bug fix, user story, codebase note, or daily log entry. Identifies the correct note type, creates or updates the note via obsidian-cli, and appends a reference to today's daily note.
---

# Codex Log

## Purpose

Save work context from the current session into Jay's Obsidian Codex vault. Route to the correct
project folder and template based on note type. Always log a reference in today's daily note.

## Note Types and Paths

- ticket / task / story  → `02-projects/<project>/tickets/<ID> - <Title>.md`
- user-story             → `02-projects/<project>/tickets/<ID> - <Title>.md`
- investigation / bug    → `02-projects/<project>/investigations/Investigation - <Topic>.md`
- codebase / doc / arch  → `02-projects/<project>/docs/<Title>.md`
- knowledge / learning   → `03-knowledge/<Title>.md`
- daily / log only       → skip note creation, daily entry only

## Active Projects

- Fair Work Commission → `02-projects/Fair Work Commission/`
- Exco Partners        → `02-projects/Exco Partners/`
- Gringotts            → `02-projects/Gringotts/`

## Frontmatter Standards

**Ticket / User Story:**
```yaml
type: ticket
ticket_id: <ID>
project: <project>
status: in-progress
priority: medium
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
tags: [ticket]
```

**Investigation:**
```yaml
type: investigation
ticket_id: <related-ID>
project: <project>
status: open
created: <YYYY-MM-DD>
resolved:
tags: [investigation]
```

**Codebase doc:**
```yaml
type: doc
project: <project>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
tags: [doc]
```

## Workflow

1. Read the vault index for full path/naming rules:
   ```
   cat ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Codex/VAULT-INDEX.md
   ```

2. Infer type, project, title, and summary from user context. Ask one question if genuinely ambiguous.

3. Build the note content: correct frontmatter + relevant sections filled from context.

4. Write the note via obsidian-cli:
   ```bash
   obsidian-cli create --vault Codex --content "<full note markdown>" "<relative/path/Note Title>"
   ```

5. Ensure today's daily note exists:
   ```bash
   obsidian-cli daily --vault Codex
   ```

6. Append the daily log entry:
   ```bash
   obsidian-cli create --vault Codex --append \
     --content "- [[<note-title>]] - <one-line summary>" \
     "$(date '+%d %b %Y - %A')"
   ```

7. Confirm what was written.

## Triggers

- "log this to codex"
- "save this ticket"
- "update my second brain"
- "record this investigation"
- "add this to my daily note"
- `/codex-log`
