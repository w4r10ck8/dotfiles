import { homedir } from 'os';
import { join } from 'path';

export const VAULT_NAME = 'Codex';
export const VAULT_PATH = join(
  homedir(),
  'Library/Mobile Documents/iCloud~md~obsidian/Documents/Codex'
);
export const DAILY_LOGS_PATH = join(VAULT_PATH, '05-Daily Logs');
