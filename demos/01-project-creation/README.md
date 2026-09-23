# Demo 01: Project Creation

**Goal**: Show a fresh Kotlin installation and create a running project on macOS.
**Time**: ~5 minutes after VM preparation; Xcode installation takes longer.
**Workspace**: `repos/01-project-creation/` on the host.

## Setup

Install tart and prepare the macOS image.

```bash
brew tap openai/tools #use openai/tools for tart as cirruslabs has auth issues
brew trust openai/tools
brew install openai/tools/tart
./macos-demo.sh prepare #this downloads a 24GB macOS image

```

## Installation (1-2 min)

1. Run the VM from your host terminal: `./macos-demo.sh run`
2. Wait for the VM to boot, the terminal opens automatically
3. Open Safari and go to kotl.in/install
4. Copy the curl command and run in the terminal (`curl -fsSL https://kotl.in/install.sh | sh`)
5. Export the path (`export PATH="$HOME/.local/bin:$PATH"`)

## Project creation and first run (2-3 min)
1. Create a new directory and enter it `mkdir demo && cd demo`
2. Run `kotlin init`, select the multiplatform app
3. Fastest to run is the Wasm app with `kotlin run -m wasm-app`
4. Explain how on first run Kotlin Toolchain provisions your environment
5. Potentially show hot reload as well `kotlin run --compose-hot-reload-mode`

## iOS provisioning

iOS does still require xcode to be installed, but Kotlin Toolchain guides you through the process.

- Run the iOS app `kotlin run -m ios-app`
- Kotlin Toolchain will give an error that xcode needs to be installed

## Reset

Shut down the demo by clicking the close button on the VM window. Then on the host:

```bash
./macos-demo.sh reset
./macos-demo.sh run
```