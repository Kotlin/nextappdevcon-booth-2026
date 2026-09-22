#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS_DIR="$SCRIPT_DIR/repos"

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

if command -v xcodebuild >/dev/null 2>&1; then
    ok "Xcode CLI tools found"
else
    fail "Xcode CLI tools required: xcode-select --install"
fi

# Optional CLI; the Toolchain sample also includes a wrapper.
if command -v kotlin >/dev/null 2>&1; then
    ok "kotlin Toolchain found ($(kotlin -v 2>&1 | head -1))"
else
    warn "kotlin Toolchain not found. Optional for Demo 03 (the sample includes a wrapper). Install from https://kotl.in/install"
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
        git clone $extra_args "$url" "$dir"
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

# Demo 01 — Liquid Glass (lg-nav branch of kotlinconf-app)
clone_or_skip "kotlinconf-app" \
    "https://github.com/JetBrains/kotlinconf-app.git"
checkout_branch "kotlinconf-app" "lg-nav"
cp "$SCRIPT_DIR/demos/01-compose-native/README.md" "$REPOS_DIR/kotlinconf-app/BOOTH_DEMO.md"

# Demo 02 — Swift Export
clone_or_skip "swift-export-sample" \
    "https://github.com/Kotlin/swift-export-sample.git" \
    "--branch artem.olkov/2.4.0_dev_demo --single-branch"
cp "$SCRIPT_DIR/demos/02-swift-export/README.md" "$REPOS_DIR/swift-export-sample/BOOTH_DEMO.md"

# Demo 03 — Kotlin Toolchain (amper branch of kotlinconf-app)
clone_or_skip "kotlinconf-app-kotlin-toolchain" \
    "https://github.com/JetBrains/kotlinconf-app.git" \
    "--branch amper --single-branch"
cp "$SCRIPT_DIR/demos/03-kotlin-toolchain/README.md" "$REPOS_DIR/kotlinconf-app-kotlin-toolchain/BOOTH_DEMO.md"

echo ""

# ─── Summary ─────────────────────────────────────────────────────────────────

echo "=============================="
echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "Repos cloned to: $REPOS_DIR"
echo ""
echo "Next steps:"
echo "  1. Open Compose Native and Swift Export in IntelliJ IDEA and let Gradle sync"
echo "  2. Open the iOS projects in Xcode as described in each demo guide"
echo "  3. Open Kotlin Toolchain in IntelliJ IDEA with the Kotlin Toolchain plugin"
echo "  4. Each cloned repo has a BOOTH_DEMO.md with the step-by-step guide"
echo ""
echo "Demo quick reference:"
echo "  Demo 01 (Compose Native):   repos/kotlinconf-app/BOOTH_DEMO.md"
echo "  Demo 02 (Swift Export):     repos/swift-export-sample/BOOTH_DEMO.md"
echo "  Demo 03 (Kotlin Toolchain): repos/kotlinconf-app-kotlin-toolchain/BOOTH_DEMO.md"
echo ""
