# Next App Dev Conf 2026 Booth Demos

Demo kit for the Next App Dev Conf 2026 booth, adapted from the KotlinConf 2026 booth demos.

## Quick setup

From your local checkout:

```bash
cd nextappdevconf-booth-2026
./install.sh
```

The installer checks your tooling, clones the three sample repositories into `repos/`, and copies each guide into its sample as `BOOTH_DEMO.md`. Run setup with internet access before the event, then build and launch each demo once.

## Prerequisites

- **Git**
- **JDK 17+** (`java -version`)
- **Xcode with CLI tools** and an **iOS 26+ simulator** for the native navigation demo
- **IntelliJ IDEA** with the **Kotlin Multiplatform plugin** for Compose Native and Swift Export
- **Kotlin Toolchain IDE plugin** for the Toolchain demo: [installation instructions](https://kotl.in/install)
- Optional: **Kotlin Toolchain CLI**; the sample also includes a `./kotlin` wrapper

The original kit recommended IntelliJ IDEA 2026.1.2 (261.24374.151), KMP plugin 261.24374.160-IJ, and Android plugin 261.24374.151. The demo branches are carried over from that kit; verify compatibility before presenting.

## Demo overview

| # | Demo | Duration | Sample branch |
|---|------|----------|---------------|
| [01](demos/01-compose-native/) | Compose + Native Navigation (Liquid Glass) | ~5 min | `lg-nav` |
| [02](demos/02-swift-export/) | Swift Export Alpha | ~8 min | `artem.olkov/2.4.0_dev_demo` |
| [03](demos/03-kotlin-toolchain/) | Kotlin Toolchain | ~5 min | `amper` |

These demos can run in any order and do not require resets between visitors. Links to sample source files in the guides are relative to the cloned sample root; open `BOOTH_DEMO.md` there to follow them.

## Repository layout

```text
demos/          Step-by-step demo guides
repos/          Sample repositories (created by install.sh, gitignored)
install.sh      One-time setup script
```

## Adding Kotlin Toolchain demos

Add further walkthroughs under `demos/03-kotlin-toolchain/` and link them from that section's `README.md`. For an independent demo, create a new numbered directory under `demos/` and add it to the overview above.

If a demo needs another sample repository, add a `clone_or_skip` call to `install.sh`, copy its guide into that sample as `BOOTH_DEMO.md`, and update the installer's quick reference. Keep downloaded samples under the gitignored `repos/` directory.

## Booth tips

- Open and build the samples before visitors arrive.
- Each guide includes timing estimates and talking points.
- For Kotlin Multiplatform library questions, point visitors to [klibs.io](https://klibs.io).
