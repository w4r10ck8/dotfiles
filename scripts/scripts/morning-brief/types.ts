export interface LinkedNote {
  title: string;
  content: string;
}

export interface StandupPrep {
  summary: string;
  sourceNotes: Array<string>;
}

export interface BriefResult {
  date: Date;
  standup: StandupPrep;
}
