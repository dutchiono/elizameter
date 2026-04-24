import type { IAgentRuntime, RouteRequest, RouteResponse } from "@elizaos/core";
import type {
  ChatHistoryResponse,
  ChatSendRequest,
  ChatSendResponse,
} from "../contracts.js";

export async function handleChatHistory(
  _req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  // STUB — phase 2 wraps the existing dashboard chat history endpoint.
  const body: ChatHistoryResponse = { turns: [] };
  res.status(200).json(body);
}

export async function handleChatSend(
  req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  const body = (req.body ?? {}) as Partial<ChatSendRequest>;
  const text = typeof body.text === "string" ? body.text : "";
  if (!text.trim()) {
    res.status(400).json({ error: "text is required" });
    return;
  }
  // STUB — phase 2 proxies to the dashboard chat endpoint and returns
  // a stream id the skin can consume via /api/widgets/chat/stream/:id.
  const response: ChatSendResponse = {
    streamId: `stub-${Date.now()}`,
  };
  res.status(200).json(response);
}

export async function handleChatStream(
  req: RouteRequest,
  res: RouteResponse,
  _runtime: IAgentRuntime,
): Promise<void> {
  const id = req.params?.id ?? "";
  // STUB — phase 2 opens an SSE stream fed by the dashboard chat turn.
  if (res.setHeader) {
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");
  }
  res.status(200);
  res.send(`event: done\ndata: {"streamId":"${id}","text":"(stub)"}\n\n`);
  res.end();
}
