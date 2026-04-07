---
description: Add a task to PersonalTodo app
---

Add a task to the PersonalTodo menubar app using the URL scheme.

The user will describe what they need to do. Extract:
- **title**: the task name (keep it short and actionable)
- **label**: the client/company name if mentioned, otherwise empty

Then run this command to add it:
```
open "personaltodo://add?title=URL+ENCODED+TITLE&label=URL+ENCODED+LABEL"
```

Make sure to URL-encode the title and label (spaces become `+`, special characters percent-encoded).

If the user gives multiple tasks at once, add each one separately.

After adding, confirm what was added.

$ARGUMENTS
