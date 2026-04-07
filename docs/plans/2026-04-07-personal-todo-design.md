# Personal Todo — macOS Menubar App

## Overview

A SwiftUI menubar app for managing daily tasks across multiple clients/companies. No dock icon — lives entirely in the menubar. All data stored locally.

## Core Flow

1. App launches on login (SMAppService)
2. On first open each day, if uncompleted tasks exist from previous days:
   - Auto-open the popover
   - Fire a macOS notification (e.g. "You have 3 tasks to review")
   - Show Morning Review screen
3. Morning Review: for each leftover task, choose "Done" (archive) or "Move to Today"
4. Once cleared, show today's task list
5. Add/complete/reorder tasks throughout the day

## Views

### Morning Review
- Shown when uncompleted tasks exist from previous days
- Must clear all leftovers before accessing today's list
- Each task shows two actions: "Done" or "Move to Today"

### Today's Tasks
- Main view — today's tasks in a single list
- Drag to reorder
- Check off tasks to complete them
- Grouped or filterable by label

### Add Task (inline)
- Input field at the bottom of the task list
- Type task title, pick or type a client label, hit Enter
- Label picker shows recent/frequently used labels
- Type a new label to create it on the fly

## Data Model

**Task:**
- `id` — UUID
- `title` — String
- `label` — String (client/company name)
- `createdDate` — Date
- `completed` — Bool
- `sortOrder` — Int (for drag-to-reorder)

**Storage:** SwiftData (local SQLite). No cloud sync, no accounts.

**Labels:** Derived from existing tasks. No separate label management UI. Unused labels naturally disappear from the picker as old tasks age out.

## Behavior

- **Launch on login:** SMAppService, toggle in the popover (on by default)
- **Morning trigger:** Track last-active date. On first activation of a new day, auto-open popover and send notification if there are leftover tasks.
- **Completed tasks:** Archived (kept in DB), not deleted. No archive UI initially — just data retention.
- **Appearance:** Follows macOS system light/dark mode automatically.

## Tech Stack

- SwiftUI
- SwiftData (persistence)
- SMAppService (launch on login)
- UserNotifications (morning notification)
- No external dependencies
