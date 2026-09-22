#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS_DIR="$SCRIPT_DIR/repos"

TOOLCHAIN_ONLY=false
case "${1:-}" in
    "") ;;
    --toolchain-only) TOOLCHAIN_ONLY=true ;;
    *) echo "Usage: $0 [--toolchain-only]" >&2; exit 2 ;;
esac

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[ok]${NC}    $1"; }
warn() { echo -e "${YELLOW}[warn]${NC}  $1"; }
fail() { echo -e "${RED}[error]${NC} $1"; exit 1; }

echo ""
echo "Next App Dev Conf 2026 Booth — Setup"
echo "=============================="
echo ""

# ─── Prerequisites ───────────────────────────────────────────────────────────

echo "Checking prerequisites..."

command -v git  >/dev/null 2>&1 && ok "git found"        || fail "git is required. Install via Xcode CLI tools: xcode-select --install"
command -v java >/dev/null 2>&1 && ok "java found"       || fail "JDK 17+ is required. Download from https://adoptium.net"

if "$TOOLCHAIN_ONLY"; then
    ok "Toolchain-only setup: Xcode check skipped"
elif command -v xcodebuild >/dev/null 2>&1; then
    ok "Xcode CLI tools found"
else
    fail "Xcode CLI tools required: xcode-select --install"
fi

# Optional CLI; the Toolchain sample also includes a wrapper.
if command -v kotlin >/dev/null 2>&1 && kotlin --help 2>&1 | grep 'init' >/dev/null; then
    ok "Kotlin Toolchain CLI found"
else
    warn "Kotlin Toolchain CLI not detected (a different kotlin command may be installed). Demo 03 uses its wrapper; Demo 05 needs https://kotl.in/install"
fi

echo ""

# ─── Clone repos ─────────────────────────────────────────────────────────────

mkdir -p "$REPOS_DIR"

clone_or_skip() {
    local name="$1"
    local url="$2"
    local dir="$REPOS_DIR/$name"
    local extra_args="${3:-}"

    if [ -d "$dir/.git" ]; then
        ok "$name already cloned — skipping"
    else
        echo "Cloning $name..."
        # shellcheck disable=SC2086
        git clone --depth 1 $extra_args "$url" "$dir"
        ok "$name cloned"
    fi
}

checkout_branch() {
    local name="$1"
    local branch="$2"
    local dir="$REPOS_DIR/$name"

    echo "Checking out $name branch $branch..."
    git -C "$dir" fetch origin "$branch" --quiet
    git -C "$dir" checkout "$branch" --quiet
    ok "$name on branch $branch"
}

echo "Cloning demo repositories..."
echo ""

if ! "$TOOLCHAIN_ONLY"; then
    # Demo 01 — Liquid Glass (lg-nav branch of kotlinconf-app)
    clone_or_skip "01-liquid-glass" \
        "https://github.com/JetBrains/kotlinconf-app.git" \
        "--branch lg-nav --single-branch"
    checkout_branch "01-liquid-glass" "lg-nav"
    cp "$SCRIPT_DIR/demos/01-liquid-glass/README.md" "$REPOS_DIR/01-liquid-glass/BOOTH_DEMO.md"

    # Demo 02 — Swift Export
    clone_or_skip "02-swift-export" \
        "https://github.com/Kotlin/swift-export-sample.git" \
        "--branch artem.olkov/2.4.0_dev_demo --single-branch"
    cp "$SCRIPT_DIR/demos/02-swift-export/README.md" "$REPOS_DIR/02-swift-export/BOOTH_DEMO.md"

fi

# Demo 03 — Kotlin Toolchain CLI (kotlin-toolchain branch of kotlinconf-app)
clone_or_skip "03-kotlin-toolchain-cli" \
    "https://github.com/JetBrains/kotlinconf-app.git" \
    "--branch kotlin-toolchain --single-branch"
cp "$SCRIPT_DIR/demos/03-kotlin-toolchain-cli/README.md" "$REPOS_DIR/03-kotlin-toolchain-cli/BOOTH_DEMO.md"

# Demo 04 — Agentic Workflow (kotlin-toolchain-nadc-chr includes MCP configs).
clone_or_skip "04-agentic-workflow" \
    "https://github.com/JetBrains/kotlinconf-app.git" \
    "--branch kotlin-toolchain-nadc-chr --single-branch"
cp "$SCRIPT_DIR/demos/04-agentic-workflow/README.md" "$REPOS_DIR/04-agentic-workflow/BOOTH_DEMO.md"

# Demo 05 — Project Creation; local starter repo; generate each new project under projects/.
NEW_PROJECT_DIR="$REPOS_DIR/05-project-creation"
mkdir -p "$NEW_PROJECT_DIR/projects"
if [ ! -d "$NEW_PROJECT_DIR/.git" ]; then
    git init --quiet "$NEW_PROJECT_DIR"
fi
cp "$SCRIPT_DIR/demos/05-project-creation/README.md" "$NEW_PROJECT_DIR/BOOTH_DEMO.md"
if ! grep -qxF '/projects/' "$NEW_PROJECT_DIR/.git/info/exclude"; then
    echo '/projects/' >> "$NEW_PROJECT_DIR/.git/info/exclude"
fi
ok "New-project playground ready"

# Keep copied presenter material out of source diffs. Existing sample edits stay intact.
for sample in 03-kotlin-toolchain-cli 04-agentic-workflow; do
    for pattern in /BOOTH_DEMO.md /booth/; do
        if ! grep -qxF "$pattern" "$REPOS_DIR/$sample/.git/info/exclude"; then
            echo "$pattern" >> "$REPOS_DIR/$sample/.git/info/exclude"
        fi
    done
done

# Install a repo-local reset command only for demos that provide one.
for demo_dir in "$SCRIPT_DIR"/demos/*; do
    repo_dir="$REPOS_DIR/$(basename "$demo_dir")"
    if [ -f "$demo_dir/reset.sh" ] && [ -d "$repo_dir/.git" ]; then
        cp "$demo_dir/reset.sh" "$repo_dir/reset.sh"
        chmod +x "$repo_dir/reset.sh"
        if ! grep -qxF '/reset.sh' "$repo_dir/.git/info/exclude"; then
            echo '/reset.sh' >> "$repo_dir/.git/info/exclude"
        fi
    fi
done

echo ""

# ─── Summary ─────────────────────────────────────────────────────────────────

echo "=============================="
echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "Repos cloned to: $REPOS_DIR"
echo ""
echo "Next steps:"
if ! "$TOOLCHAIN_ONLY"; then
    echo "  - Open Liquid Glass and Swift Export in IntelliJ IDEA and let Gradle sync"
    echo "  - Open the iOS projects in Xcode as described in each demo guide"
fi
echo "  - Open Kotlin Toolchain in IntelliJ IDEA with the Kotlin Toolchain plugin"
echo "  - Open the agent workspace; its .mcp.json already configures Hot Reload and klibs MCP"
echo "  - Between agent demos, run ./reset.sh from repos/04-agentic-workflow"
echo "  - Use the new-project workspace for installation and kotlin init"
echo "  Each workspace has a BOOTH_DEMO.md with walkthrough and reset instructions"
echo ""
echo "Demo quick reference:"
if ! "$TOOLCHAIN_ONLY"; then
    echo "  Demo 01 (Liquid Glass):   repos/01-liquid-glass/BOOTH_DEMO.md"
    echo "  Demo 02 (Swift Export):     repos/02-swift-export/BOOTH_DEMO.md"
fi
echo "  Demo 03 (Kotlin Toolchain CLI): repos/03-kotlin-toolchain-cli/BOOTH_DEMO.md"
echo "  Demo 04 (Agentic Workflow):  repos/04-agentic-workflow/BOOTH_DEMO.md"
echo "  Demo 05 (Project Creation):     repos/05-project-creation/BOOTH_DEMO.md"
