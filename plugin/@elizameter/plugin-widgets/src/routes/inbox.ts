import type { IAgentRuntime, RouteRequest, RouteResponse } from "@elizaos/core";
import type { InboxResponse } from "../contracts.js";

export async function handleInbox(
  _req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  // STUB — phase 2 will project over the Gmail plugin's unread cache.
  const body: InboxResponse = {
    unreadCount: 0,
    items: [],
  };
  res.status(200).json(body);
}
