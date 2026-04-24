# Elizameter

Rainmeter desktop widgets for [Milady](https://github.com/milady-ai/milady)
/ elizaOS. Ambient, always-on-screen access to your local agent: chat,
email, calendar, tasks, and status — all on the Windows desktop, no
Electron window needed.

## What's in the box

Two halves, one repo:

1. **`plugin/@elizameter/plugin-widgets/`** — elizaOS plugin that
   registers `/api/widgets/*` HTTP routes on your local Milady runtime
   via `runtime.routes`. Stable JSON contracts designed for Rainmeter's
   `WebParser` measure.
2. **`Skins/Elizameter/`** — Rainmeter skins that consume those routes.

## Widgets

- **Chat** — comprehensive floating panel, scrollable transcript,
  streaming replies, Enter to send.
- **Inbox** — unread count + top senders, click a row to summarize.
- **Agenda** — today's calendar events, current/next highlighted.
- **NextEvent** — single big-glance tile: "Next: Standup in 12m".
- **Tasks** — open reminders with complete / snooze actions.
- **Status** — ambient agent online indicator + active skill.

## Install

Windows only. Requires Rainmeter + a running local Milady.

```powershell
git clone https://github.com/dutchiono/elizameter.git
cd elizameter
./install.ps1
```

The installer (a) links the plugin into your local Milady plugins dir,
(b) copies skins into `%APPDATA%\Rainmeter\Skins\Elizameter`, (c) tells
Rainmeter to refresh. Restart your Milady dev server and load skins
from Rainmeter's Manage panel.

## Configuration

Skins read the Milady API base URL from `%APPDATA%\Rainmeter\Skins\Elizameter\config.ini`:

```ini
[Elizameter]
ApiBaseUrl=http://127.0.0.1:31337
```

Default matches the Milady dev API port. Point it anywhere reachable if
you run the agent on a different host.

## Status

Personal project. Moves fast, may break.

## License

MIT.
