#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASELINE_BRANCH="kotlin-toolchain-nadc-chr"

case "${1:-}" in
    "") ;;
    --help|-h)
        echo "Usage: $0"
        echo "Discard tracked changes in the agent demo clone."
        echo "Reset to origin/$BASELINE_BRANCH, also discarding local demo commits."
        echo "Uses the existing branch ref without network access; does not run git clean."
        exit 0
        ;;
    *) echo "Usage: $0 [--help]" >&2; exit 2 ;;
esac

if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Run the reset.sh copied into repos/03-agentic-workflow by install.sh." >&2
    exit 1
fi

# Restrict the destructive reset to the dedicated demo branch and clone.
if [ "$(git -C "$REPO_DIR" branch --show-current)" != "$BASELINE_BRANCH" ]; then
    echo "Switch the agent clone to $BASELINE_BRANCH before resetting." >&2
    exit 1
fi

BASELINE_REF="refs/remotes/origin/$BASELINE_BRANCH"
if ! git -C "$REPO_DIR" show-ref --verify --quiet "$BASELINE_REF"; then
    echo "Fetch the demo baseline in $REPO_DIR first:" >&2
    echo "git fetch --depth 1 origin +refs/heads/$BASELINE_BRANCH:$BASELINE_REF" >&2
    exit 1
fi

echo "Resetting $REPO_DIR to $BASELINE_REF..."
git -C "$REPO_DIR" reset --hard "$BASELINE_REF"
echo "Tracked files reset; build caches and presenter files are not cleaned."
echo "Use MCP reload (or restart), confirm the break icons are missing, and start a fresh agent conversation."
