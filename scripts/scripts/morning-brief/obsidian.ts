import { join } from 'path';
import { existsSync, readFileSync, writeFileSync } from 'fs';
import { VAULT_NAME, VAULT_PATH, DAILY_LOGS_PATH } from './config';
import type { LinkedNote, StandupPrep } from './types';

// ─── Path helpers ────────────────────────────────────────────────────────────

function pad(n: number): string {
  return String(n).padStart(2, '0');
}

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

export function getDailyNotePath(date: Date): string {
  const year = date.getFullYear();
  const month = pad(date.getMonth() + 1);
  const day = pad(date.getDate());
  const monthName = MONTHS[date.getMonth()];
  const dayName = DAYS[date.getDay()];
  const filename = `${day} ${monthName} ${year} - ${dayName}.md`;
  return join(DAILY_LOGS_PATH, String(year), month, filename);
}

// ─── Daily note creation ─────────────────────────────────────────────────────

export function createDailyNote(): void {
  const result = Bun.spawnSync(['obsidian-cli', 'daily', '--vault', VAULT_NAME], {
    stdout: 'pipe',
    stderr: 'pipe',
  });

  if (result.exitCode !== 0) {
    const err = new TextDecoder().decode(result.stderr);
    throw new Error(`obsidian-cli daily failed: ${err}`);
  }
}

// ─── Read yesterday's work section ───────────────────────────────────────────

function extractSection(content: string, sectionKeyword: string): Array<string> {
  const lines = content.split('\n');
  let inSection = false;
  const result: Array<string> = [];

  for (const line of lines) {
    if (line.startsWith('## ') && line.includes(sectionKeyword)) {
      inSection = true;
      continue;
    }
    if (inSection && line.startsWith('## ')) break;
    if (inSection) result.push(line);
  }

  return result;
}

export function readDailySection(date: Date, sectionKeyword: string): string | null {
  const notePath = getDailyNotePath(date);

  if (!existsSync(notePath)) {
    console.log(`  Note not found: ${notePath}`);
    return null;
  }

  const content = readFileSync(notePath, 'utf-8');
  const lines = extractSection(content, sectionKeyword);
  const text = lines.join('\n').trim();
  return text.length > 0 ? text : null;
}

export function readTodaysWorkSection(date: Date): string | null {
  return readDailySection(date, "Today's Work");
}

export function readTodaysWorkLinks(date: Date): Array<string> {
  const notePath = getDailyNotePath(date);

  if (!existsSync(notePath)) return [];

  const content = readFileSync(notePath, 'utf-8');
  const lines = extractSection(content, "Today's Work");
  const links: Array<string> = [];

  for (const line of lines) {
    const stripped = line.replace(/<!--.*?-->/g, ''); // strip HTML comments
    const matches = stripped.matchAll(/\[\[([^\]]+)\]\]/g);
    for (const match of matches) {
      const title = match[1]!.split('|')[0]!.trim(); // handle [[title|alias]]
      links.push(title);
    }
  }

  return links;
}

// ─── Read a note via obsidian-cli ─────────────────────────────────────────────

export function readNoteContent(wikiLink: string): string | null {
  // Try obsidian-cli print first
  const result = Bun.spawnSync(
    ['obsidian-cli', 'print', '--vault', VAULT_NAME, wikiLink],
    { stdout: 'pipe', stderr: 'pipe' }
  );

  if (result.exitCode === 0) {
    const text = new TextDecoder().decode(result.stdout).trim();
    if (text.length > 0) return text.slice(0, 6000); // cap at ~6k chars
  }

  // Fallback: glob search in vault for matching filename
  const searchResult = Bun.spawnSync(
    ['find', VAULT_PATH, '-name', `${wikiLink}.md`, '-not', '-path', '*/node_modules/*'],
    { stdout: 'pipe', stderr: 'pipe' }
  );

  if (searchResult.exitCode === 0) {
    const foundPath = new TextDecoder().decode(searchResult.stdout).trim().split('\n')[0];
    if (foundPath && existsSync(foundPath)) {
      return readFileSync(foundPath, 'utf-8').slice(0, 6000);
    }
  }

  return null;
}

// ─── Generate standup summary via claude --print ──────────────────────────────

export async function generateStandupSummary(notes: Array<LinkedNote>): Promise<string> {
  const notesText = notes
    .map(n => `### ${n.title}\n${n.content}`)
    .join('\n\n---\n\n');

  const prompt = `You are helping Jay prepare his daily standup update. Standups are short — the whole summary must be scannable in 30 seconds.

Based on the work notes below, write a standup summary with these exact sections:

✅ **Done**
🚧 **In Progress**
💬 **Discussions / Decisions** (omit if none)
🚫 **Blockers**

Rules:
- Infer Done vs In Progress from [x] / [ ] checkbox state.
- Each top-level bullet: the core fact in ≤10 words. Ticket/PR IDs if present.
- If a bullet genuinely needs more detail (e.g. multiple sub-tasks), add one level of nested bullets — each sub-bullet ≤8 words. Never nest otherwise.
- Discussions: one line per decision already made. Include who confirmed it (bold name). No backstory.
- Blockers: anything waiting on someone else, missing a user story/ticket, or pending a confirmation. Always include who it's pending (bold name). Write "None" if truly none — never omit the section.
- If an item has both a decision AND a pending action, split it: decision → Discussions, pending action → Blockers.
- No filler. No long sentences. Terse.

Formatting rules (apply consistently):
- Ticket and PR IDs: prefix with # only, no bold (Obsidian treats these as tags)
- User story / bug IDs (#US-XXXX, #BUG-XXXX) go at the start of the top-level bullet — e.g. "#US-15514: description"
- PR IDs (#PR-XXXX) are child items of their parent ticket — always in a nested bullet, never on the top-level line — e.g. "    - #PR-6174 raised"
- Version numbers and code/package names: backticks — \`v14\`, \`v15\`, \`npm\`, \`Next.js\`
- Technical terms, key concepts, and important outcomes: bold — **hydration mismatches**, **SSR/CSR gaps**
- Slack channels, group names, system names: backticks — \`CSP ICT & EXCO\`, \`chambers\`
- People's names: bold — **Jimmy**, **Bhavesh**
- Time estimates: bold — **~3-5 days**
- UI labels and feature names that are exact strings: double quotes — "Pay Now", "View more info"
- Nested bullet indentation: 4 spaces

Work notes:
${notesText}`;

  const claudeResult = Bun.spawnSync(['claude', '--print', prompt], {
    stdout: 'pipe',
    stderr: 'pipe',
  });

  if (claudeResult.exitCode === 0) {
    return new TextDecoder().decode(claudeResult.stdout).trim();
  }

  const claudeErr = new TextDecoder().decode(claudeResult.stderr);
  console.log(`  claude --print failed (${claudeErr.trim()}), falling back to codex...`);

  const codexResult = Bun.spawnSync(['codex', 'exec', prompt], {
    stdout: 'pipe',
    stderr: 'pipe',
  });

  if (codexResult.exitCode !== 0) {
    const codexErr = new TextDecoder().decode(codexResult.stderr);
    throw new Error(`claude --print failed: ${claudeErr}\ncodex exec fallback also failed: ${codexErr}`);
  }

  return new TextDecoder().decode(codexResult.stdout).trim();
}

// ─── Patch ## Standup Prep section in today's note ───────────────────────────

export function patchStandupPrep(date: Date, summary: string): void {
  const notePath = getDailyNotePath(date);

  if (!existsSync(notePath)) {
    throw new Error(`Daily note not found at: ${notePath}`);
  }

  const content = readFileSync(notePath, 'utf-8');
  const lines = content.split('\n');

  const sectionStart = lines.findIndex(l => l.startsWith('## ') && l.includes('Standup Prep'));
  if (sectionStart === -1) {
    // Section missing — append it
    const patched = content.trimEnd() + '\n\n## Standup Prep\n' + summary + '\n';
    writeFileSync(notePath, patched, 'utf-8');
    return;
  }

  // Find end of section (next h2 or end of file)
  let sectionEnd = lines.length;
  for (let i = sectionStart + 1; i < lines.length; i++) {
    if (lines[i]!.startsWith('## ')) {
      sectionEnd = i;
      break;
    }
  }

  const before = lines.slice(0, sectionStart + 1);
  const after = lines.slice(sectionEnd);

  const patched = [
    ...before,
    summary,
    '',
    ...after,
  ].join('\n');

  writeFileSync(notePath, patched, 'utf-8');
}
