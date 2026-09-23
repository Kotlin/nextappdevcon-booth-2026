# Demo 01: Project Creation

**Goal**: Show a fresh Kotlin installation and create a running project on macOS.
**Time**: ~5 minutes after VM preparation
**Workspace**: `repos/01-project-creation/` on the host.

## Setup

Install tart and prepare the macOS image.

```bash
brew tap openai/tools #use openai/tools for tart as cirruslabs has auth issues
brew trust openai/tools
brew install openai/tools/tart
./macos-demo.sh prepare #this downloads a massive 62GB macOS image

```

## Demo the installation (~1 min)

1. Run the VM from your host terminal: `./macos-demo.sh run`
2. Wait for the VM to boot, the terminal opens automatically
3. Open Safari and go to kotl.in/install
4. Copy the curl command and run in the terminal (`curl -fsSL https://kotl.in/install.sh | sh`)
5. Export the path (`export PATH="$HOME/.local/bin:$PATH"`)

## Demo the project creation and first run (~2-3 min)
1. Create a new directory and enter it `mkdir demo && cd demo`
2. Run `kotlin init`, select the multiplatform app
3. Fastest to run is the Wasm app with `kotlin run -m wasm-app` (~25s)
4. Explain how on first run Kotlin Toolchain provisions your environment
5. Potentially show hot reload as well `kotlin run --compose-hot-reload-mode` (~ 60s)

## Demo the iOS provisioning (~4 min)
iOS requires xcode to be installed, Kotlin Toolchain provides the right instructions at the right time. This VM already has Xcode installed, so we do skip the installing and license acceptance.
1. Run the iOS app `kotlin run -m ios-app` (~4 min)
2. With the first run, all dependencies and simulators are downloaded and installed
3. Subsequent runs are much faster `kotlin run -m ios-app` (~10 s)

## Reset

Shut down the demo by clicking the close button on the VM window. Then on the host:

```bash
./macos-demo.sh reset
./macos-demo.sh run
```