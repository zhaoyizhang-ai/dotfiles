---
name: diagnose-claude-code
description: Diagnose Claude Code startup, model-routing, alias, MCP, plugin, and tool-availability problems. Use when the user says cc/ds/Claude Code is misconfigured, a tool is missing, MCP is not loading, or the wrong model/provider is being used.
allowed-tools: Read, Write, Edit, Bash(cat *), Bash(grep *), Bash(find *), Bash(ls *), Bash(which *), Bash(echo *)
metadata:
  category: utility
  tags: [claude-code, diagnosis, mcp, configuration, troubleshooting]
  triggers:
    - diagnose cc
    - claude code problem
    - MCP not loading
    - tool missing
    - 诊断Claude Code
    - Claude Code问题
    - MCP问题
    - 工具缺失
---

# Diagnose Claude Code

This skill is for Claude Code host problems rather than application-code bugs.

## Scope

Use it when the issue is about:

- `cc`, `ds`, or other shell aliases launching the wrong model/provider
- Claude Code not seeing an MCP server or plugin
- A model path working in one alias but not another
- Tools existing on disk but not appearing to the model
- Claude Code settings, `.claude.json`, `settings.json`, or `.mcp.json` confusion

## First look here

Before anything else, read these two files in this order:

1. `__HOME__/Desktop/ai-aliases.md`
2. `~/.zshrc`

Reason:

- `ai-aliases.md` is the user's canonical alias map for `cc`, `ds`, and `mi`
- `~/.zshrc` confirms what the shell actually launches
- Only after those two should you inspect the sourced env files and Claude Code config

## Fast checklist

1. Read `__HOME__/Desktop/ai-aliases.md` and note which alias the user actually means.
2. Confirm the alias definition in `~/.zshrc`.
3. Read the env script that alias sources:
   - `cc` → `~/claude_env.sh`
   - `ds` → `~/ds.sh`
   - `mi` → `~/mi.sh`
4. Identify the effective model endpoint and model name.
5. Check Claude Code settings in:
   - `~/.claude/settings.json`
   - `~/.claude/settings.local.json`
   - `~/.claude.json`
6. Run:
   - `claude mcp list`
   - `claude mcp get <server>`
7. Verify whether the missing capability is:
   - a shell/env problem
   - an MCP registration problem
   - a server-health problem
   - a model-capability misconception

## Diagnosis rules

- Distinguish `cc` from `ds` explicitly. They may source different env files and hit different providers.
- Default to trusting `__HOME__/Desktop/ai-aliases.md` for the intended alias meaning, then use `~/.zshrc` to verify the live wiring.
- Do not assume a remembered pipeline is actually wired into Claude Code. Check whether it is registered as MCP/plugin/tool.
- If a model is "multimodal" only via preprocessing, say that clearly. OCR/tool augmentation is not the same as native vision.
- Prefer exact file/line references and exact commands over vague descriptions.

## Desired output

When reporting findings, give:

1. What alias/path is actually being used
2. What provider/model it resolves to
3. Whether the relevant MCP server is registered
4. Whether the server is healthy
5. The smallest concrete fix

## Common root causes

- Alias points at the wrong env script
- `ai-aliases.md` says one thing but `~/.zshrc` is launching something else
- MCP server exists as a script or note but was never registered
- MCP server is registered but missing required env vars
- The user expected `cc` and `ds` to share config, but only one path exports the needed values
- A remembered "working pipeline" is only a standalone script, not a Claude Code tool
