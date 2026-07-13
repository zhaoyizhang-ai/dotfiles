#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  create-research-project.sh [options] <project-name>

Options:
  -d <dir>      Parent directory for projects (default: ~/.deep-research-codex)
  -m <mode>     research or brainstorm
  -r            Resume/check an existing project; do not create

This creates a Codex-friendly project using the preserved Claude Deep Research
Framework assets. It does not launch Claude or Codex.
USAGE
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$SKILL_DIR/assets/original-framework"

PROJECTS_DIR="${RESEARCH_DIR:-$HOME/.deep-research-codex}"
PROJECT_MODE=""
RESUME=false

while [ $# -gt 0 ]; do
  case "$1" in
    -d)
      PROJECTS_DIR="$2"
      shift 2
      ;;
    -m)
      PROJECT_MODE="$2"
      shift 2
      ;;
    -r)
      RESUME=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

PROJECT_NAME="${1:-}"

if [ -z "$PROJECT_NAME" ]; then
  usage >&2
  exit 1
fi

if [ -n "$PROJECT_MODE" ] && [ "$PROJECT_MODE" != "research" ] && [ "$PROJECT_MODE" != "brainstorm" ]; then
  echo "Invalid mode: $PROJECT_MODE. Use research or brainstorm." >&2
  exit 1
fi

PROJECT_DIR="$PROJECTS_DIR/$PROJECT_NAME"

if [ "$RESUME" = true ]; then
  if [ ! -d "$PROJECT_DIR" ]; then
    echo "Project does not exist: $PROJECT_DIR" >&2
    exit 1
  fi
  echo "$PROJECT_DIR"
  exit 0
fi

if [ -d "$PROJECT_DIR" ]; then
  echo "Project already exists: $PROJECT_DIR" >&2
  echo "$PROJECT_DIR"
  exit 0
fi

mkdir -p "$PROJECT_DIR"

ln -s "$TEMPLATE_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
ln -s "$TEMPLATE_DIR/.claude" "$PROJECT_DIR/.claude"

for doc in README.md GETTING-STARTED.md LICENSE; do
  [ -f "$TEMPLATE_DIR/$doc" ] && ln -s "$TEMPLATE_DIR/$doc" "$PROJECT_DIR/$doc"
done

mkdir -p \
  "$PROJECT_DIR/context/from-human" \
  "$PROJECT_DIR/context/from-internet" \
  "$PROJECT_DIR/context/from-history" \
  "$PROJECT_DIR/prompts/queue" \
  "$PROJECT_DIR/prompts/run/initial" \
  "$PROJECT_DIR/prompts/run/subsequent" \
  "$PROJECT_DIR/prompts/drafting" \
  "$PROJECT_DIR/outputs/individual" \
  "$PROJECT_DIR/outputs/aggregated/mk-combined" \
  "$PROJECT_DIR/outputs/aggregated/pdf" \
  "$PROJECT_DIR/outputs/aggregated/diagram-enrichments" \
  "$PROJECT_DIR/outputs/reformatted/tts-safe-txt" \
  "$PROJECT_DIR/outputs/reformatted/ssml" \
  "$PROJECT_DIR/outputs/brainstorm/ideation-rounds" \
  "$PROJECT_DIR/outputs/brainstorm/idea-board" \
  "$PROJECT_DIR/outputs/brainstorm/anchor-cards" \
  "$PROJECT_DIR/outputs/brainstorm/evaluation" \
  "$PROJECT_DIR/outputs/brainstorm/concept-briefs" \
  "$PROJECT_DIR/outputs/brainstorm/critique" \
  "$PROJECT_DIR/notes" \
  "$PROJECT_DIR/scratchpad" \
  "$PROJECT_DIR/pipeline/audio-dropoff/in-queue" \
  "$PROJECT_DIR/pipeline/audio-dropoff/processed"

find "$PROJECT_DIR" -type d -empty -exec touch "{}/.gitkeep" \;

if [ -f "$TEMPLATE_DIR/.gitignore" ]; then
  cp "$TEMPLATE_DIR/.gitignore" "$PROJECT_DIR/.gitignore"
fi

if [ -n "$PROJECT_MODE" ]; then
  printf '%s\n' "$PROJECT_MODE" > "$PROJECT_DIR/.project-mode"
fi

cat > "$PROJECT_DIR/AGENTS.md" <<'AGENTS'
# AGENTS.md - Codex Deep Research Framework

Use the Codex skill `$deep-research-framework` for this project.

Preserve the original Claude framework symlinks:

- `CLAUDE.md`
- `.claude/`

Directory conventions:

- `context/from-human/`: user requirements
- `context/from-internet/`: gathered sources and research notes
- `context/from-history/`: session summaries
- `prompts/queue/`: research plans
- `prompts/run/initial/`: initial prompts
- `prompts/run/subsequent/`: follow-up prompts
- `outputs/individual/`: focused findings
- `outputs/aggregated/mk-combined/`: synthesized reports
- `outputs/brainstorm/`: ideation, anchor cards, scoring, critiques
- `notes/`: logs
- `scratchpad/`: working notes

Treat Claude slash commands as workflow names:

- `/initiate-research` -> use the skill's research mode
- `/initiate-brainstorm` -> use the skill's brainstorm mode
- `/critique-ideas` -> use the skill's critique mode
AGENTS

echo "$PROJECT_DIR"
