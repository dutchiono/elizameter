/**
 * @elizameter/plugin-widgets
 *
 * Registers /api/widgets/* HTTP routes on the local Milady runtime so
 * Rainmeter skins (Elizameter/Skins/*) can read and write via
 * simple JSON contracts. See ./contracts.ts for field shapes.
 *
 * Install path: link this package into your local Milady plugin set
 * (the repo's install.ps1 does this). All routes use `rawPath: true`
 * so the paths stay exactly as declared, and `public: true` so they
 * work without auth — fine for localhost.
 */

import type { Plugin } from "@elizaos/core";
import { handleCalendarNext } from "./routes/calendar-next.js";
import { handleCalendarToday } from "./routes/calendar-today.js";
import {
  handleChatHistory,
  handleChatSend,
  handleChatStream,
} from "./routes/chat.js";
import { handleInbox } from "./routes/inbox.js";
import { handleStatus } from "./routes/status.js";
import {
  handleTaskComplete,
  handleTaskSnooze,
  handleTasks,
} from "./routes/tasks.js";

export const widgetsPlugin: Plugin = {
  name: "elizameter-widgets",
  description:
    "Registers /api/widgets/* HTTP routes for Rainmeter skins (Elizameter).",
  routes: [
    {
      type: "GET",
      path: "/api/widgets/status",
      name: "widgets-status",
      public: true,
      rawPath: true,
      handler: handleStatus,
    },
    {
      type: "GET",
      path: "/api/widgets/inbox",
      name: "widgets-inbox",
      public: true,
      rawPath: true,
      handler: handleInbox,
    },
    {
      type: "GET",
      path: "/api/widgets/calendar/today",
      name: "widgets-calendar-today",
      public: true,
      rawPath: true,
      handler: handleCalendarToday,
    },
    {
      type: "GET",
      path: "/api/widgets/calendar/next",
      name: "widgets-calendar-next",
      public: true,
      rawPath: true,
      handler: handleCalendarNext,
    },
    {
      type: "GET",
      path: "/api/widgets/tasks",
      name: "widgets-tasks",
      public: true,
      rawPath: true,
      handler: handleTasks,
    },
    {
      type: "POST",
      path: "/api/widgets/tasks/:id/complete",
      name: "widgets-task-complete",
      public: true,
      rawPath: true,
      handler: handleTaskComplete,
    },
    {
      type: "POST",
      path: "/api/widgets/tasks/:id/snooze",
      name: "widgets-task-snooze",
      public: true,
      rawPath: true,
      handler: handleTaskSnooze,
    },
    {
      type: "GET",
      path: "/api/widgets/chat/history",
      name: "widgets-chat-history",
      public: true,
      rawPath: true,
      handler: handleChatHistory,
    },
    {
      type: "POST",
      path: "/api/widgets/chat/send",
      name: "widgets-chat-send",
      public: true,
      rawPath: true,
      handler: handleChatSend,
    },
    {
      type: "GET",
      path: "/api/widgets/chat/stream/:id",
      name: "widgets-chat-stream",
      public: true,
      rawPath: true,
      handler: handleChatStream,
    },
  ],
};

export default widgetsPlugin;
export * from "./contracts.js";
