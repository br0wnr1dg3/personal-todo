# PersonalTodo

macOS menubar app for managing daily tasks across clients/companies.

## Build & Install

```bash
cd PersonalTodo
bash bundle.sh
cp -r build/PersonalTodo.app /Applications/
open /Applications/PersonalTodo.app
```

Requires Xcode (for SwiftData macro compilation).

## URL Scheme

External tools can add tasks via:
```
open "personaltodo://add?title=My+task&label=Client+Name"
```

## Claude Commands

- `/add-task` — quickly add a task (e.g. `/add-task Review proposal for Acme`)
- `/review-day` — interactive daily review that pulls from Granola, Gmail, Slack and helps you plan tomorrow's tasks

## Connecting Data Sources (for /review-day)

The daily review command works with these MCP integrations. Connect whichever you use:

- **Granola** — for meeting transcripts and action items
- **Gmail** — for email action items and follow-ups  
- **Slack** — for messages needing follow-up

These are connected through your Claude account settings, not this app.
