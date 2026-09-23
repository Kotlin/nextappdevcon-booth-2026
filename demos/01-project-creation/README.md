# Demo 01: Project Creation

**Goal**: Show a fresh Kotlin installation and create a running project on macOS.
**Time**: ~5 minutes after VM preparation; Xcode installation takes longer.
**Workspace**: `repos/01-project-creation/` on the host.

## Setup

Install tart and prepare the macOS image.

```bash
brew tap openai/tools #use openai/tools as cirruslabs has auth issues
brew trust openai/tools
brew install openai/tools/tart
./macos-demo.sh prepare #this downloads a 24GB macOS image
./macos-demo.sh run #starts the VM to demo in
```

## Installation and project creation

Open Terminal inside the macOS VM and visit [kotl.in/install](https://kotl.in/install):

```bash
curl -fsSL https://kotl.in/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

kotlin -v
kotlin --help

mkdir -p ~/demo
cd ~/demo

kotlin init
kotlin run --compose-hot-reload
```

## iOS provisioning

- Run the iOS app to show the guided provisioning
```bash
kotlin run -m iosApp
```

## Reset

Shut down the demo using **Apple menu → Shut Down inside the guest**. Then on the host:

```bash
./macos-demo.sh reset
./macos-demo.sh run
```