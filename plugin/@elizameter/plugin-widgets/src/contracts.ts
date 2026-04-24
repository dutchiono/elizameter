/**
 * Stable JSON contracts for /api/widgets/*.
 *
 * Rules (see docs/plans/2026-04-24-rainmeter-milady-widgets.md in the
 * Milady repo for rationale):
 *
 * 1. Additive only after v1. Fields can be added; never removed or renamed.
 *    Breaking changes bump to /api/widgets/v2/*.
 * 2. Always JSON, never HTML.
 * 3. Shapes stay flat where possible (Rainmeter regex pain past 2 levels).
 * 4. Timestamps are ISO-8601 strings.
 * 5. Deeplinks are absolute URLs.
 */

export interface StatusResponse {
  online: boolean;
  agentName: string;
  activeSkill: string | null;
  lastTurnAt: string | null; // ISO-8601
  trajectoryCountToday: number;
}

export interface InboxItem {
  from: string;
  subject: string;
  snippet: string;
  receivedAt: string; // ISO-8601
  deeplink: string;
}

export interface InboxResponse {
  unreadCount: number;
  items: InboxItem[];
}

export interface CalendarEvent {
  start: string; // ISO-8601
  end: string;
  title: string;
  location: string;
  deeplink: string;
}

export interface CalendarTodayResponse {
  now: string; // ISO-8601, server's current time
  events: CalendarEvent[];
}

export type CalendarNextResponse =
  | { empty: true }
  | {
      empty: false;
      title: string;
      start: string;
      minutesUntil: number;
    };

export interface TaskItem {
  id: string;
  title: string;
  dueAt: string | null; // ISO-8601
  priority: "low" | "normal" | "high";
}

export interface TasksResponse {
  items: TaskItem[];
}

export interface ChatTurn {
  id: string;
  role: "user" | "agent";
  text: string;
  at: string; // ISO-8601
}

export interface ChatHistoryResponse {
  turns: ChatTurn[];
}

export interface ChatSendRequest {
  text: string;
}

export interface ChatSendResponse {
  streamId: string;
}
