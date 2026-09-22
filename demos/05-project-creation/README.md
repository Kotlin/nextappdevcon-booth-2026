# Demo 05: Project Creation

**Goal**: Go from the installation page to a running new Kotlin project.
**Time**: 5 minutes. **Workspace**: `repos/05-project-creation/`.
This is a separate local Git repository with an empty `projects/` playground, not a KotlinConf clone.

## Before visitors arrive

- Open [kotl.in/install](https://kotl.in/install) and the workspace in a terminal.
- Install the Kotlin Toolchain IDE plugin and rehearse the new-project wizard.
- Use a disposable OS account or VM to demonstrate a genuinely fresh installation. The booth setup does not uninstall your existing tooling or alter your shell profile.
- Warm the toolchain and template dependencies in your normal account. Installation and library downloads require internet access; keep a rehearsed project available as a fallback.

## Walkthrough

1. Show the install page and its macOS/Linux command (Windows instructions are on the page):

   ```bash
   curl -fsSL https://kotl.in/install.sh | sh
   export PATH="$HOME/.local/bin:$PATH"
   kotlin --help
   ```

   Run the installer live only in the prepared account, or explain that it is already installed. Confirm help lists `init`, `build`, and `run`: another executable named `kotlin` may be the older compiler runner.

2. From this workspace, create a fresh directory for each run:

   ```bash
   mkdir -p projects
   demo_dir="$(mktemp -d "$PWD/projects/hello-kotlin.XXXXXX")"
   cd "$demo_dir"
   kotlin init
   ```

   Select **JVM console application** for the shortest walkthrough. Let the audience see the available templates before choosing.

3. Open the generated YAML and source. Run:

   ```bash
   ./kotlin run
   ```

   Change the greeting to “Hello, Next App Dev Conf!” and run again. Show the generated wrapper: the next developer can use the project's toolchain without a separate global install.

4. Optional IDE path: **New Project → Kotlin**, select the Kotlin Toolchain option supported by your installed plugin, and generate into a new directory under `projects/`. Show the generated configuration and IDE run action. Rehearse exact wizard labels against the installed IDE version.

## Reset

Close the generated project and return to this workspace root. Repeat step 2 to create a fresh directory; old runs remain available for comparison. Each demo run starts empty without deleting files or uninstalling the toolchain. `projects/` is ignored in the local starter repo. Delete old runs manually after the event if desired.

## References

- [Install Kotlin Toolchain](https://kotl.in/install)
- [CLI installation and project templates](https://kotlin-toolchain.org/latest/cli/)
- [IDE setup](https://kotlin-toolchain.org/latest/getting-started/ide-setup/)
