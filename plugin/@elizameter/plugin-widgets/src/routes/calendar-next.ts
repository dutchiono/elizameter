import type { IAgentRuntime, RouteRequest, RouteResponse } from "@elizaos/core";
import type { CalendarNextResponse } from "../contracts.js";

export async function handleCalendarNext(
  _req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  // STUB — phase 2 computes the next event from the Calendar plugin.
  const body: CalendarNextResponse = { empty: true };
  res.status(200).json(body);
}
