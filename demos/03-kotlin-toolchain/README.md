# Demo 03: Kotlin Toolchain

**Goal**: Show how the Kotlin Toolchain replaces complex build files with plain YAML — the KotlinConf app, targeting 6 platforms, configured in ~10 lines per module.

**Time**: ~5 min | **Reset**: No

---

## Setup (before the demo)

- Open `repos/kotlinconf-app-kotlin-toolchain/` in IntelliJ IDEA, let it sync
- Ensure Kotlin Toolchain is installed (both IDE plugin and CLI: [kotl.in/install](https://kotl.in/install))

---

## Demo steps

**1. Top-level project** — [`project.yaml`](project.yaml)
- 10 lines: a flat list of modules — no plugins block, no version catalogs, no classpath config

**2. Desktop module** — [`app/desktopApp/module.yaml`](app/desktopApp/module.yaml)
- `product: jvm/app` — one line declares what this module produces
- `apply:` — reuses shared template configs for Compose and Metro
- `dependencies:` — just `../shared` and three Compose libs

**3. Shared multiplatform module** — [`app/shared/module.yaml`](app/shared/module.yaml)
- `product: lib` with all platforms listed — Android, iOS, JVM, JS, WASM
- Dependencies declared once; the toolchain generates the per-platform source sets
- _"No `sourceSets { commonMain { dependencies { ... } } }` boilerplate — just a flat dependency list."_

**4. Run it** from `repos/kotlinconf-app-kotlin-toolchain/`: `./kotlin run -m desktopApp`
- The `kotlin` wrapper ships with the repo, so no separate tool install is needed
- When you do install the Kotlin Toolchain, you can use `kotlin run -m desktopApp` instead of `./kotlin run -m desktopApp`
- You can also run the app from the run configurations in the IDE.

---

## Quick answers

**Is it stable?**
Alpha. Already useful today for JVM and Multiplatform projects.

**How do I install it?**
[kotl.in/install](https://kotl.in/install)

**What can I do with it today?**
Create projects, manage dependencies, build and run apps. Works for JVM and multiplatform. IDE integration is already there — run configurations in IntelliJ IDEA, Android Studio support coming.

**What do the commands look like?**
`kotlin init`, `kotlin run`, `kotlin build`, `kotlin test`, and more.

**Isn't this what Amper was?**
Yes. Everything built as Amper now lives in the Kotlin Toolchain.

**Will it replace Gradle/Maven/Bazel?**
No. Those stay for projects that need flexibility or scale. The Toolchain is a great default for the many projects that don't need to configure a separate build tool.

**Does it support Android and iOS?**
Yes — Android, iOS, JVM, and Web (Web requires some [manual configuration](https://kotlin-toolchain.org/latest/user-guide/product-types/wasm-app/?h=web#running-your-application)). It integrates with AGP and Xcode Build for platform-specific linking and packaging.

**What's planned next?**
Agentic tooling, linting, cross-platform dependency management, more IDE integration.
