---
name: install-skill-codex-claude
description: Install and configure a third-party skill for both Codex and local Claude Code on this machine. Use when the user wants a skill added to both hosts, especially when setup depends on local alias/env conventions, MCP registration, or repo-specific install steps.
allowed-tools: Read, Write, Edit, Bash(cat *), Bash(grep *), Bash(find *), Bash(ls *), Bash(mkdir *), Bash(cp *), Bash(mv *), Bash(chmod *)
metadata:
  category: utility
  tags: [skill-installation, codex, claude-code, configuration]
  triggers:
    - install skill
    - add skill
    - 安装技能
    - 添加技能
    - 配置技能
---

# Install Skill In Codex And Claude Code

Use this skill when a user wants the same skill configured in both **Codex** and **Claude Code** on this Mac.

## Mandatory First Reads

Before changing anything:

1. Read `__HOME__/Desktop/ai-aliases.md` to learn the user's local launcher aliases and which env files they rely on.
2. Read the user-provided repository README and any official docs the README links to.
3. Inspect the current local targets only after reading docs:
   - Codex: `~/.codex/config.toml`, `~/.codex/skills/`
   - Claude Code: `~/.claude/settings.json`, `~/.claude/skills/`, `claude mcp list`

## Hard Rules

- Prefer the **standard documented flow** from the repository or official docs.
- Do **not** invent flags, config paths, agent names, or install commands.
- If Codex/Claude Code exact steps are missing, use the repo's documented **manual clone/copy** path instead of guessing.
- If neither an official path nor a documented manual path exists, stop and ask the user for the source URL or missing instruction.
- If the user provided a repo/URL, treat that as the primary source of truth.

## Secret Handling

- Put secrets only in the env files already tied to this machine's launchers from `ai-aliases.md`.
- For this machine:
  - Codex env file: `~/.codex-env.sh`
  - Claude Code env file: `~/claude_env.sh`
- Do not create new ad hoc secret files unless the user explicitly asks for that.

## Preferred Workflow

1. Read the target repo README and linked official docs.
2. Confirm where the skill files live in the repo.
3. Register MCP or other host integrations exactly as documented:
   - Codex: prefer the documented `~/.codex/config.toml` snippet when provided.
   - Claude Code: prefer the documented `claude mcp add ...` command when provided.
4. Install the skill using the documented host-specific method:
   - Use marketplace/installer commands only when the repo explicitly documents them for that host.
   - Otherwise use the documented manual clone/copy path.
5. Verify the result with lightweight checks:
   - skill directory exists in both hosts
   - config entry exists where expected
   - `claude mcp list` shows the server if Claude Code was configured through MCP
6. Tell the user if a host restart or new session is required before the new skill/MCP tools appear.

## Reporting Back

When done, report:

- which docs were followed
- which files were changed
- which verification checks passed
- whether Codex and/or Claude Code need restart/new session
