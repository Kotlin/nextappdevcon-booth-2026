# Demo 04: Agentic Workflow

**Goal**: Show an agent investigating and fixing a UI bug in a running Compose app.

**Time**: ~3 min | **Reset**: Yes | **Branch**: `kotlin-toolchain-nadc-chr`

---

## Setup

- Open this repo in IntelliJ IDEA and a fresh agent conversation
- Make sure the checked-in [`.mcp.json`](.mcp.json) is recognized by the agent, both CHR and klibs.io
- Do a dry-run of the demo to make sure all is working. 

---

## Demo

**1. Icons are not showing up**
- The project comes with a bug, icons are not showing up for the breaks sections
- Let's ask the agent to investigate and fix it
> I started adding icons to the schedule’s break sections, but they aren’t showing up. Can you investigate why and fix it? Use the running app to verify the result.

**2. Watch the investigation and fix**
- The agent finds the problem in  [`ServiceEvents.kt`](app/ui-components/src/org/jetbrains/kotlinconf/ui/components/ServiceEvents.kt) and uses Compose Hot Reload
- Compose Hot Reload can scroll, click and verify the UI, not just whether the code compiles
- Compose Hot Reload will also be available in headless mode, allowing for usage in CI/CD workflows

**3. Try any other changes**
- Feel free to try any other changes, including dependency changes
- The klibs.io MCP server helps with finding suitable libraries and versions

---

## Reset

Roll back all changes in the repo to get back to baseline or run `./reset.sh`