# Next App Dev Conf 2026 Booth Demos

Demo kit for the Next App Dev Conf 2026 booth, adapted from the KotlinConf 2026 booth demos.

## Quick setup

From your local checkout:

```bash
cd nextappdevconf-booth-2026
./install.sh
```

The installer checks your tooling, prepares the sample repositories and a local new-project playground under `repos/`, and copies each guide into its workspace as `BOOTH_DEMO.md`. New clones fetch only the latest commit of the demo branch (`--depth 1`); existing clones are reused. Run setup with internet access before the event, then build and launch each demo once.

For just the CLI, agentic workflow, and project creation demos (no Xcode requirement):

```bash
./install.sh --toolchain-only
```

The CLI and agent demos use independent KotlinConf clones. The installation demo uses a separate local Git repo with a `projects/` playground. Toolchain-only setup preserves existing clones and source edits; it does not switch or reset their branches. Before rehearsing, check the CLI clone is on `kotlin-toolchain` and the agent clone is on `kotlin-toolchain-nadc-chr`.

## Prerequisites

- **Git**
- **JDK 17+** (`java -version`)
- **Xcode with CLI tools** and an **iOS 26+ simulator** for the native navigation demo
- **IntelliJ IDEA** with the **Kotlin Multiplatform plugin** for Liquid Glass and Swift Export
- **Kotlin Toolchain IDE plugin** for the Kotlin Toolchain demos: [installation instructions](https://kotl.in/install)
- **Kotlin Toolchain CLI** for the new-project demo; KotlinConf also includes a `./kotlin` wrapper
- **MCP-capable coding agent** for Demo 04, with klibs.io and a compatible Compose Hot Reload MCP connection

The original kit recommended IntelliJ IDEA 2026.1.2 (261.24374.151), KMP plugin 261.24374.160-IJ, and Android plugin 261.24374.151. The demo branches are carried over from that kit; verify compatibility before presenting.

## Demo overview

| # | Demo | Duration | Sample branch |
|---|------|----------|---------------|
| [01](demos/01-liquid-glass/) | Liquid Glass | ~5 min | `lg-nav` |
| [02](demos/02-swift-export/) | Swift Export | ~8 min | `artem.olkov/2.4.0_dev_demo` |
| [03](demos/03-kotlin-toolchain-cli/) | Liquid Glass | `repos/01-liquid-glass/` | Stop the app |
| Swift Export | `repos/02-swift-export/` | Stop the app |
| Kotlin Toolchain CLI | ~5 min | `kotlin-toolchain` |
| [04](demos/04-agentic-workflow/) | Agentic Workflow | ~5 min | `kotlin-toolchain-nadc-chr` (separate clone) |
| [05](demos/05-project-creation/) | Project Creation | ~5 min | Local starter repo |

These demos can run in any order. Each guide describes its reset procedure; the agent demo needs source edits reset, and the new-project demo uses a fresh directory each time. Links to sample source files in the guides are relative to the cloned sample root; open `BOOTH_DEMO.md` there to follow them.

## Repository layout

```text
demos/          Step-by-step demo guides
repos/          Sample repositories (created by install.sh, gitignored)
install.sh      One-time setup script
repos/04-agentic-workflow/reset.sh  Restore the agent demo branch baseline (copied by setup)
```

## Demo workspaces

Folders under `repos/` use the same names as their guides under `demos/`.

| Demo | Open this directory | Reset |
|------|---------------------|-------|
| Kotlin Toolchain CLI | `repos/03-kotlin-toolchain-cli/` | Stop the app; no source edits |
| Agentic Workflow | `repos/04-agentic-workflow/` | `./reset.sh` from this repo |
| Project Creation | `repos/05-project-creation/` | Create another empty directory under `projects/` |

**Agent demo:** `kotlin-toolchain-nadc-chr` contains the broken demo baseline and all MCP configuration in `.mcp.json`. Enable that project configuration in your agent; no separate MCP setup files are installed. The reset script restores tracked files to the fetched branch state, without downloading anything or cleaning build caches. See the agent guide for the walkthrough and baseline refresh command.

## Booth tips

- Open and build the samples before visitors arrive.
- Each guide includes timing estimates and talking points.
- For Kotlin Multiplatform library questions, point visitors to [klibs.io](https://klibs.io).
