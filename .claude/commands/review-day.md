---
description: Review today's meetings and emails, then add tasks for tomorrow
---

You are helping the user review their day and plan tasks for tomorrow. This is an interactive conversation.

## Step 1: Gather context

Pull information from available sources. Use whichever MCP tools are connected:

- **Granola**: Use Granola MCP tools to fetch today's meeting transcripts. Look for action items, follow-ups, and commitments made.
- **Gmail**: Use Gmail MCP tools to check today's emails. Look for action items, requests, and things that need responses.
- **Slack**: If Slack MCP is connected, check for messages that need follow-up.

If a source isn't connected, skip it and note which sources were checked.

## Step 2: Extract action items

From all sources, compile a list of potential tasks. For each one, identify:
- What needs to be done (the task)
- Which client/company it's for (the label)
- Where it came from (meeting, email, slack)

## Step 3: Walk through with the user

Present the tasks one at a time or in small groups. For each:
- Describe the task and its source
- Ask: "Add this? (yes/no/edit)"
- If they want to edit, let them refine the title or label
- If yes, add it immediately using:

```
open "personaltodo://add?title=URL+ENCODED+TITLE&label=URL+ENCODED+LABEL"
```

## Step 4: Open-ended check

After going through all extracted items, ask:
"Anything else you want to add for tomorrow that I might have missed?"

Add any additional tasks they mention.

## Step 5: Summary

Show a final summary of all tasks added, grouped by label.

$ARGUMENTS
