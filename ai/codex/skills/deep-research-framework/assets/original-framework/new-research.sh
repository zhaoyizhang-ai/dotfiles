#!/bin/bash
# new-research.sh - Create an isolated research project and launch Claude Code
#
# Usage:
#   ./new-research.sh <project-name>                    # create + launch claude
#   ./new-research.sh -m research <project-name>        # start in research mode
#   ./new-research.sh -m brainstorm <project-name>      # start in brainstorm mode
#   ./new-research.sh -r <project-name>                 # resume existing project
#   ./new-research.sh -d /path/to/dir <project-name>    # custom output directory
#   RESEARCH_DIR=/path/to/dir ./new-research.sh <project-name>
#
# Each project shares the framework (CLAUDE.md, agents, commands) via symlinks,
# but gets its own isolated state directories (outputs, context, prompts, etc.)

set -euo pipefail

TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Parse flags ---
RESUME=false
CUSTOM_DIR=""
PROJECT_NAME=""
PROJECT_MODE=""
CLAUDE_ARGS=()
while [ $# -gt 0 ]; do
    case "$1" in
        -r)          RESUME=true; shift ;;
        -n)          PROJECT_NAME="$2"; shift 2 ;;
        -d)          CUSTOM_DIR="$2"; shift 2 ;;
        -m)          PROJECT_MODE="$2"; shift 2 ;;
        --)          shift; CLAUDE_ARGS+=("$@"); break ;;
        -*)          CLAUDE_ARGS+=("$1"); shift ;;
        *)           break ;;
    esac
done

# Validate mode if provided
if [ -n "$PROJECT_MODE" ] && [ "$PROJECT_MODE" != "research" ] && [ "$PROJECT_MODE" != "brainstorm" ]; then
    echo "Error: Invalid mode '$PROJECT_MODE'. Must be 'research' or 'brainstorm'."
    exit 1
fi

# Priority: -d flag > RESEARCH_DIR env var > default
if [ -n "$CUSTOM_DIR" ]; then
    PROJECTS_DIR="$CUSTOM_DIR"
else
    PROJECTS_DIR="${RESEARCH_DIR:-$HOME/.deep-research}"
fi

# --- Usage ---
if [ -z "${PROJECT_NAME:-}" ] && [ -n "${1:-}" ] && [[ "$1" != -* ]]; then
    PROJECT_NAME="$1"
    shift
fi

if [ -z "${PROJECT_NAME:-}" ]; then
    echo "Usage: $0 [options] [-n <project-name> | <project-name>] [-- claude-args...]"
    echo ""
    echo "Options:"
    echo "  -n <name>                   Project name"
    echo "  -m <mode>                   Project mode: 'research' or 'brainstorm'"
    echo "  -r                          Resume existing project"
    echo "  -d <dir>                    Custom output directory (default: ~/.deep-research)"
    echo "  --dangerously-skip-permissions  Pass to claude"
    echo "  --                          All args after this are passed to claude"
    echo ""
    echo "Examples:"
    echo "  $0 ai-safety-survey"
    echo "  $0 -m research ai-safety-survey"
    echo "  $0 -m brainstorm idea-generation"
    echo "  $0 -d ~/my-research ai-safety-survey"
    echo "  $0 --dangerously-skip-permissions ai-safety-survey"
    echo "  $0 ai-safety-survey -- --model sonnet"
    echo "  RESEARCH_DIR=~/research $0 my-project"
    echo ""
    echo "Existing projects:"
    if [ -d "$PROJECTS_DIR" ]; then
        ls -1 "$PROJECTS_DIR" 2>/dev/null || echo "  (none)"
    else
        echo "  (none)"
    fi
    exit 1
fi

PROJECT_DIR="$PROJECTS_DIR/$PROJECT_NAME"

# --- Resume mode ---
if [ "$RESUME" = true ]; then
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "Error: Project '$PROJECT_NAME' does not exist."
        echo ""
        echo "Existing projects:"
        ls -1 "$PROJECTS_DIR" 2>/dev/null || echo "  (none)"
        exit 1
    fi
    echo "Resuming project: $PROJECT_NAME"
    if [ -f "$PROJECT_DIR/.project-mode" ]; then
        echo "Mode: $(cat "$PROJECT_DIR/.project-mode")"
    fi
    cd "$PROJECT_DIR" && exec claude "${CLAUDE_ARGS[@]}"
fi

# --- Guard against duplicate ---
if [ -d "$PROJECT_DIR" ]; then
    echo "Project '$PROJECT_NAME' already exists. Resuming..."
    if [ -f "$PROJECT_DIR/.project-mode" ]; then
        echo "Mode: $(cat "$PROJECT_DIR/.project-mode")"
    fi
    cd "$PROJECT_DIR" && exec claude "${CLAUDE_ARGS[@]}"
fi

echo "Creating research project: $PROJECT_NAME"
echo "Location: $PROJECT_DIR"
echo ""

mkdir -p "$PROJECT_DIR"

# --- Symlink immutable framework files ---
ln -s "$TEMPLATE_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
ln -s "$TEMPLATE_DIR/.claude" "$PROJECT_DIR/.claude"

# Optional docs (symlink only if they exist)
for doc in README.md GETTING-STARTED.md; do
    [ -f "$TEMPLATE_DIR/$doc" ] && ln -s "$TEMPLATE_DIR/$doc" "$PROJECT_DIR/$doc"
done

# --- Create fresh mutable directory structure ---
# Context
mkdir -p "$PROJECT_DIR/context/from-human"
mkdir -p "$PROJECT_DIR/context/from-internet"
mkdir -p "$PROJECT_DIR/context/from-history"

# Prompts
mkdir -p "$PROJECT_DIR/prompts/queue"
mkdir -p "$PROJECT_DIR/prompts/run/initial"
mkdir -p "$PROJECT_DIR/prompts/run/subsequent"
mkdir -p "$PROJECT_DIR/prompts/drafting"

# Outputs
mkdir -p "$PROJECT_DIR/outputs/individual"
mkdir -p "$PROJECT_DIR/outputs/aggregated/mk-combined"
mkdir -p "$PROJECT_DIR/outputs/aggregated/pdf"
mkdir -p "$PROJECT_DIR/outputs/aggregated/diagram-enrichments"
mkdir -p "$PROJECT_DIR/outputs/reformatted/tts-safe-txt"
mkdir -p "$PROJECT_DIR/outputs/reformatted/ssml"

# Notes, scratchpad, pipeline
mkdir -p "$PROJECT_DIR/notes"
mkdir -p "$PROJECT_DIR/scratchpad"
mkdir -p "$PROJECT_DIR/pipeline/audio-dropoff/in-queue"
mkdir -p "$PROJECT_DIR/pipeline/audio-dropoff/processed"

# Brainstorm
mkdir -p "$PROJECT_DIR/prompts/brainstorm/techniques"
mkdir -p "$PROJECT_DIR/prompts/brainstorm/evaluation"
mkdir -p "$PROJECT_DIR/prompts/brainstorm/concept"
mkdir -p "$PROJECT_DIR/outputs/brainstorm/ideation-rounds"
mkdir -p "$PROJECT_DIR/outputs/brainstorm/idea-board"
mkdir -p "$PROJECT_DIR/outputs/brainstorm/anchor-cards"
mkdir -p "$PROJECT_DIR/outputs/brainstorm/evaluation"
mkdir -p "$PROJECT_DIR/outputs/brainstorm/concept-briefs"
mkdir -p "$PROJECT_DIR/outputs/brainstorm/critique"

# Add .gitkeep to empty dirs
for dir in \
    context/from-internet context/from-history \
    prompts/run/subsequent prompts/drafting \
    outputs/individual outputs/aggregated/mk-combined \
    outputs/aggregated/pdf outputs/aggregated/diagram-enrichments \
    outputs/reformatted/tts-safe-txt outputs/reformatted/ssml \
    scratchpad pipeline/audio-dropoff/in-queue pipeline/audio-dropoff/processed \
    prompts/brainstorm/techniques prompts/brainstorm/evaluation prompts/brainstorm/concept \
    outputs/brainstorm/ideation-rounds outputs/brainstorm/idea-board \
    outputs/brainstorm/anchor-cards outputs/brainstorm/evaluation \
    outputs/brainstorm/concept-briefs \
    outputs/brainstorm/critique
do
    touch "$PROJECT_DIR/$dir/.gitkeep"
done

# --- Copy .gitignore ---
if [ -f "$TEMPLATE_DIR/.gitignore" ]; then
    cp "$TEMPLATE_DIR/.gitignore" "$PROJECT_DIR/.gitignore"
fi

echo "Project '$PROJECT_NAME' created."

# --- Write mode marker if specified ---
if [ -n "$PROJECT_MODE" ]; then
    echo "$PROJECT_MODE" > "$PROJECT_DIR/.project-mode"
    echo "Mode: $PROJECT_MODE"

    # Build initial prompt to auto-start the correct workflow
    if [ "$PROJECT_MODE" = "research" ]; then
        INIT_PROMPT="Please read CLAUDE.md then run /initiate-research to begin the deep research workflow."
    else
        INIT_PROMPT="Please read CLAUDE.md then run /initiate-brainstorm to begin the brainstorm workflow."
    fi
    echo ""
    cd "$PROJECT_DIR" && exec claude -p "$INIT_PROMPT" "${CLAUDE_ARGS[@]}"
else
    echo ""
    cd "$PROJECT_DIR" && exec claude "${CLAUDE_ARGS[@]}"
fi
