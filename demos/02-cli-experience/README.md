# Demo 02: CLI Experience

**Goal**: Run a real multiplatform app and explain the commands as you go.
**Time**: 5 minutes. **Workspace**: `repos/02-cli-experience/`.
**Branch**: `kotlin-toolchain`.

## Before visitors arrive

Open this workspace in IntelliJ IDEA with the Kotlin Toolchain plugin. Run the desktop app once to download dependencies and check that conference data loads. Use the project's `./kotlin` wrapper: the global `kotlin` executable may belong to the older Kotlin command-line compiler.

## Walkthrough

Run these commands from the sample root, one at a time:

```bash
./kotlin --help
./kotlin show modules
./kotlin run --help
./kotlin build -m desktopApp
./kotlin run -m desktopApp
```

1. Show help: commands are discoverable without memorizing build tasks.
2. List the modules: one project contains several platform apps and shared code.
3. Explain `-m desktopApp`: choose the desktop app for a quick booth demo.
4. Build, then run. Show the schedule and open a session in the app.
5. Open `project.yaml`, then `app/desktopApp/module.yaml`: connect the module names to the YAML configuration. Briefly show `app/shared/module.yaml` for shared code and dependencies.

Optional: `./kotlin test --help` introduces testing without launching the entire multiplatform test suite during a short demo. Use `./kotlin show --help` to discover other inspection commands.

**Talking point**: “The wrapper selects the project's toolchain. Build, run, and test are normal CLI commands; the module describes what we are building.”

## Reset

Close the app or stop the run with Ctrl+C. This walkthrough makes no source changes; keep the build cache warm. Use the separate agent workspace for edits.

## References

- [Kotlin CLI](https://kotlin-toolchain.org/latest/cli/)
- [KotlinConf Toolchain branch](https://github.com/JetBrains/kotlinconf-app/tree/kotlin-toolchain)
