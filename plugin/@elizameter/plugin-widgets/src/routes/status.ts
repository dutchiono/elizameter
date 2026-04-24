import type { IAgentRuntime, RouteRequest, RouteResponse } from "@elizaos/core";
import type { StatusResponse } from "../contracts.js";

export async function handleStatus(
  _req: RouteRequest,
  res: RouteResponse,
  runtime: IAgentRuntime,
): Promise<void> {
  // STUB — phase 1 returns a shape-correct fake. Real data in phase 2.
  const body: StatusResponse = {
    online: true,
    agentName: runtime.character?.name ?? "Agent",
    activeSkill: null,
    lastTurnAt: null,
    trajectoryCountToday: 0,
  };
  res.status(200).json(body);
}
