# PersonalTodo

A simple macOS menubar app for managing daily tasks across multiple clients and companies.

- **Menubar-only** — no dock icon, always one click away
- **Labels** — tag tasks by client/company
- **Morning review** — forces you to clear yesterday's leftovers before starting fresh
- **Daily reminder** — configurable notification to plan your day
- **Launch on login** — starts automatically when you boot your Mac
- **AI-powered daily planning** — Claude Code commands to review meetings/emails and add tasks

## Prerequisites

- macOS 14+
- [Xcode](https://apps.apple.com/us/app/xcode/id497799835) (required for SwiftData compilation)

## Install

```bash
git clone https://github.com/YOUR_USERNAME/personal-todo.git
cd personal-todo/PersonalTodo
bash bundle.sh
cp -r build/PersonalTodo.app /Applications/
open /Applications/PersonalTodo.app
```

After installing, click the checklist icon in your menubar to get started.

## Usage

### Adding tasks

Click the menubar icon. Type a label (client name) and task title at the bottom, then hit Enter.

### Completing tasks

Click the circle next to a task to mark it done.

### Morning review

If you have uncompleted tasks from previous days, the app will show them when it first opens each day. For each task, choose **Done** (archive it) or **Today** (carry it forward).

### Daily reminder

Toggle "Daily reminder" in the footer and set your preferred time. You'll get a macOS notification each day to review your tasks.

### Reordering

Use the up/down chevrons on the right side of each task to change order.

## Claude Code Integration

PersonalTodo includes custom Claude Code commands for AI-powered task management. Install [Claude Code](https://claude.ai/claude-code), then run commands from the `personal-todo` directory.

### Quick add

```
/add-task Review quarterly report for Acme Corp
```

Adds a task instantly via the URL scheme.

### Daily review

```
/review-day
```

Interactive session that:
1. Pulls today's meeting transcripts from **Granola**
2. Checks today's emails from **Gmail**
3. Checks messages from **Slack**
4. Extracts action items from all sources
5. Walks you through each one — add, skip, or edit
6. Asks if you have anything else to add

### Connecting data sources

The `/review-day` command works with MCP integrations connected through your Claude account. Connect whichever you use:

- **[Granola](https://granola.ai)** — meeting transcripts and action items
- **[Gmail](https://mail.google.com)** — email action items and follow-ups
- **[Slack](https://slack.com)** — messages needing follow-up

These are configured in your Claude settings, not in this app.

## URL Scheme

Any script or tool can add tasks programmatically:

```bash
open "personaltodo://add?title=My+task+title&label=Client+Name"
```

Parameters:
- `title` (required) — the task name
- `label` (optional) — client/company name

## Development

```bash
cd PersonalTodo
swift build        # debug build
swift build -c release  # release build
bash bundle.sh     # build + create .app bundle
```

## License

MIT
