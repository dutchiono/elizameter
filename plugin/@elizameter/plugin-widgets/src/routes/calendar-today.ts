import type { IAgentRuntime, RouteRequest, RouteResponse } from "@elizaos/core";
import type { CalendarTodayResponse } from "../contracts.js";

export async function handleCalendarToday(
  _req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  // STUB — phase 2 will project over the Calendar plugin's event cache.
  const body: CalendarTodayResponse = {
    now: new Date().toISOString(),
    events: [],
  };
  res.status(200).json(body);
}
