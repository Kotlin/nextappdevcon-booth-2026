# NextAppDevConf 2026 Booth Demos

Demo kit for the NextAppDevConf 2026 booth.

## Demos

The guide folders under `demos/` and the working repos under `repos/` use the same names.

| # | Demo guide | Working repo | Time | Sample branch |
|---|------------|--------------|------|---------------|
| 01 | [Project Creation](demos/01-project-creation/README.md) | `repos/01-project-creation/` | ~5 min | No branch needed, a new project is created every time |
| 02 | [CLI Experience](demos/02-cli-experience/README.md) | `repos/02-cli-experience/` | ~5 min | `kotlin-toolchain` |
| 03 | [Agentic Workflow](demos/03-agentic-workflow/README.md) | `repos/03-agentic-workflow/` | ~3 min | `kotlin-toolchain-nadc-chr` |
| 04 | [Liquid Glass](demos/04-liquid-glass/README.md) | `repos/04-liquid-glass/` | ~5 min | `kotlin-toolchain-nadc-lg` |
| 05 | [Swift Export](demos/05-swift-export/README.md) | `repos/05-swift-export/` | ~8 min | `artem.olkov/2.4.0_dev_demo` |

## Setup

From the booth kit root run in stall and open each repo and to follow the setup steps:

```bash
./install.sh
```

## Prerequisites

- **Git and JDK 17+** for setup and the sample projects.
- **IntelliJ IDEA** with the **Kotlin Toolchain plugin**: [installation instructions](https://kotl.in/install).
- **Kotlin Toolchain CLI** for Project Creation. The KotlinConf samples include a `./kotlin` wrapper.
- **Tart on an Apple Silicon Mac** for the disposable Project Creation VM (optional; prepare its base before the demo).
- **An MCP-capable coding agent** for Agentic Workflow. Its branch already includes `.mcp.json` with Compose Hot Reload and klibs.io configuration; enable that project configuration in your agent.
- **Kotlin Multiplatform plugin and Xcode with CLI tools** for Liquid Glass and Swift Export. Liquid Glass requires an **iOS 26+ simulator**. See each guide for its IDE and Xcode setup.