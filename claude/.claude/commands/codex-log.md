Log work to the Codex second brain vault.

Arguments: $ARGUMENTS

Steps:

1. Read VAULT-INDEX.md at:
   ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Codex/VAULT-INDEX.md

2. Infer from $ARGUMENTS and current session context:
   - note type: ticket | user-story | investigation | codebase-doc | knowledge | daily-only
   - project name (match to active projects listed in VAULT-INDEX.md)
   - title / ticket ID / topic
   - summary of work done, decisions made, blockers
   Ask one question only if the note type or project is genuinely ambiguous.

3. Note type routing:
   - ticket / task        → 02-projects/<project>/tickets/<ID> - <Title>.md     (template: Ticket.md)
   - user-story           → 02-projects/<project>/tickets/<ID> - <Title>.md     (template: User Story.md)
   - investigation / bug  → 02-projects/<project>/investigations/Investigation - <Topic>.md
   - codebase / doc       → 02-projects/<project>/docs/<Title>.md               (template: Docos.md)
   - knowledge            → 03-knowledge/<Title>.md
   - daily-only           → skip note creation, go straight to step 5

4. Create or update the note:
   - New note: read the correct template from 06-templates/, fill all frontmatter fields and sections
   - Existing note: append to the relevant section (Implementation Notes / Debugging Trail / Changelog)
     and update `status` + `updated` in frontmatter
   - File naming: follow VAULT-INDEX.md conventions exactly

5. Ensure today's daily note exists:
   Run shell command: obsidian-cli daily

6. Append to ## Today's Work in today's daily note:
   - [[<note-title>]] - <one-line summary of what was done>

7. Report: confirm the file path created/updated and the daily log line appended.
