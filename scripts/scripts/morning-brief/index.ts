/**
 * morning-brief — Codex standup prep
 *
 * Each morning:
 *   1. Creates today's daily note via obsidian-cli (no-op if exists)
 *   2. Reads yesterday's ## Today's Work wiki links
 *   3. Reads each linked note's content
 *   4. Generates a standup summary via `claude --print`
 *   5. Patches today's ## Standup Prep section
 *
 * Usage:
 *   morning-brief                  normal run
 *   DRY_RUN=1 morning-brief        skip writes, print summary to console
 *
 * First-time setup:
 *   obsidian-cli set-default Codex
 *   launchctl load ~/Library/LaunchAgents/com.jay.morning-brief.plist
 */

import {
  createDailyNote,
  readTodaysWorkSection,
  readDailySection,
  readTodaysWorkLinks,
  readNoteContent,
  generateStandupSummary,
  patchStandupPrep,
  getDailyNotePath,
} from './obsidian';
import type { LinkedNote } from './types';

const isDryRun = process.env['DRY_RUN'] === '1';

function getPreviousWorkingDay(date: Date): Date {
  const d = new Date(date.getTime());
  do {
    d.setTime(d.getTime() - 86_400_000);
  } while (d.getDay() === 0 || d.getDay() === 6); // skip Sun (0) and Sat (6)
  return d;
}

async function run(): Promise<void> {
  const now = new Date();
  console.log(`\nMorning Brief — ${now.toLocaleString('en-AU', { timeZone: 'Australia/Melbourne' })}`);
  if (isDryRun) console.log('(dry run)\n');
  console.log('---');

  // Skip weekends entirely
  const day = now.getDay();
  if (day === 0 || day === 6) {
    console.log('Weekend — nothing to do');
    return;
  }

  // 1. Create today's daily note (idempotent)
  if (!isDryRun) {
    console.log('Creating daily note...');
    createDailyNote();
    console.log(`  ${getDailyNotePath(now)}`);
  }

  // 2. Get previous working day (skip weekends)
  const prevWorkday = getPreviousWorkingDay(now);
  const prevLabel = prevWorkday.toLocaleDateString('en-AU', { weekday: 'long', day: 'numeric', month: 'short', timeZone: 'Australia/Melbourne' });
  console.log(`Reading ${prevLabel}'s work...`);

  // 2a. Raw section content (inline bullets/checkboxes)
  const rawSection = readTodaysWorkSection(prevWorkday);

  // 2b. Wiki-linked notes
  const links = readTodaysWorkLinks(prevWorkday);
  if (links.length > 0) {
    console.log(`  Found ${links.length} wiki link${links.length === 1 ? '' : 's'}: ${links.join(', ')}`);
  }

  // 3. Build notes array
  console.log('Reading note contents...');
  const notes: Array<LinkedNote> = [];

  if (rawSection) {
    notes.push({ title: 'Daily Log', content: rawSection });
  }

  const notesSection = readDailySection(prevWorkday, 'Notes / Decisions');
  if (notesSection) {
    notes.push({ title: 'Notes & Decisions', content: notesSection });
  }

  for (const title of links) {
    const content = readNoteContent(title);
    if (!content) {
      console.log(`  Warning: could not find note "${title}"`);
    } else {
      notes.push({ title, content });
    }
  }

  if (notes.length === 0) {
    console.log('  No work content found — nothing to summarise');
    return;
  }

  // 4. Generate standup summary
  console.log('Generating standup summary...');
  const summary = await generateStandupSummary(notes);

  if (isDryRun) {
    console.log('\n--- Standup Prep (dry run) ---\n');
    console.log(summary);
    console.log('\n--- End ---\n');
    return;
  }

  // 5. Patch today's note
  console.log('Writing standup prep to daily note...');
  patchStandupPrep(now, summary);

  const elapsed = ((Date.now() - now.getTime()) / 1000).toFixed(1);
  console.log(`\nDone in ${elapsed}s`);
}

run().catch((err: unknown) => {
  console.error('\nMorning Brief failed:', err instanceof Error ? err.message : err);
  process.exit(1);
});
