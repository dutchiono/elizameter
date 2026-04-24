import type { IAgentRuntime, RouteRequest, RouteResponse } from "@elizaos/core";
import type { TasksResponse } from "../contracts.js";

export async function handleTasks(
  _req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  // STUB — phase 2 reads from the reminders / task store.
  const body: TasksResponse = { items: [] };
  res.status(200).json(body);
}

export async function handleTaskComplete(
  req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  const id = req.params?.id ?? "";
  // STUB — phase 2 marks task complete.
  res.status(200).json({ ok: true, id });
}

export async function handleTaskSnooze(
  req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  const id = req.params?.id ?? "";
  const rawMinutes = req.body?.minutes;
  const minutes = typeof rawMinutes === "number" ? rawMinutes : 0;
  // STUB — phase 2 snoozes the task.
  res.status(200).json({ ok: true, id, minutes });
}
