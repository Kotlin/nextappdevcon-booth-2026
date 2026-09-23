#!/usr/bin/env bash
set -euo pipefail

# Separate names avoid reusing an existing vanilla VM when switching to Xcode.
# Reset remains scoped to the disposable demo and preserves its base.
BASE_VM="nextapp-project-creation-xcode-base"
DEMO_VM="nextapp-project-creation-xcode-demo"
MACOS_IMAGE="${MACOS_IMAGE:-ghcr.io/cirruslabs/macos-tahoe-xcode:latest}"

usage() {
    echo "Usage: $0 [prepare|run|reset|--help]"
    echo "  prepare  Download a macOS base with Xcode once; preserve an existing base."
    echo "  run      Open the demo in a macOS window, cloning the base if needed (default)."
    echo "  reset    Wipe the stopped demo VM and clone the stopped local base again."
    echo "Base: $BASE_VM   Disposable VM: $DEMO_VM"
    echo "Set MACOS_IMAGE before prepare to choose another Tart image or local base."
}

fail() { echo "$1" >&2; exit 1; }

if [ "$#" -gt 1 ]; then
    usage >&2
    exit 2
fi
case "${1:-run}" in
    prepare|run|reset) action="${1:-run}" ;;
    --help|-h) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
esac

if [ "$(uname -s)" != Darwin ] || [ "$(uname -m)" != arm64 ]; then
    fail "This demo needs an Apple Silicon Mac. Run it from a native macOS terminal, outside Docker."
fi
command -v tart >/dev/null 2>&1 || fail "Install Tart first:
  brew tap openai/tools
  brew trust openai/tools
  brew install openai/tools/tart
Answer y when Homebrew asks to install Tart and its softnet dependency."

# Fail on a Tart inventory error rather than treating inaccessible VMs as absent.
LOCAL_VMS="$(tart list --source local --quiet)"
has_vm() { printf '%s\n' "$LOCAL_VMS" | grep -qxF -- "$1"; }
require_stopped() {
    local state
    state="$(tart get "$1" --format json | plutil -extract State raw -o - -)"
    [ "$state" = stopped ] || fail "Shut down $1 using Apple menu > Shut Down first (current state: $state)."
}
require_base() {
    has_vm "$BASE_VM" || fail "Prepare the base first: $0 prepare"
    require_stopped "$BASE_VM"
}

case "$action" in
    prepare)
        if has_vm "$BASE_VM"; then
            echo "Base already exists; preserving it: $BASE_VM"
            exit 0
        fi
        if has_vm "$MACOS_IMAGE"; then
            require_stopped "$MACOS_IMAGE"
        fi
        echo "Preparing $BASE_VM from $MACOS_IMAGE (the first download is large)..."
        tart clone "$MACOS_IMAGE" "$BASE_VM"
        tart set "$BASE_VM" --cpu 4 --memory 8192 --display 1440x900
        echo "Base ready. Start the demo: $0 run"
        ;;
    run)
        if ! has_vm "$DEMO_VM"; then
            require_base
            tart clone "$BASE_VM" "$DEMO_VM"
        fi
        echo "Opening $DEMO_VM. Existing changes are kept; use '$0 reset' for a clean run."
        exec tart run "$DEMO_VM"
        ;;
    reset)
        # Validate the source and VM state before deleting any demo data.
        require_base
        if has_vm "$DEMO_VM"; then
            require_stopped "$DEMO_VM"
            echo "Discarding all changes in $DEMO_VM..."
            tart delete "$DEMO_VM"
        fi
        tart clone "$BASE_VM" "$DEMO_VM"
        echo "Clean demo ready. Start it: $0 run"
        ;;
esac
