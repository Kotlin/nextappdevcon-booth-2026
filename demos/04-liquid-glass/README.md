# Demo 04: Liquid Glass

**Goal**: Show CMP's iOS flexibility — native SwiftUI shell wrapping shared Compose content.

**Time**: ~5 min | **Reset**: No | **Branch**: `kotlin-toolchain-nadc-lg`

---

## Setup

- Run `./kotlin run -m iosApp -p iosSimulatorArm64`
- From Xcode: open [`module.xcworkspace`](app/iosApp/module.xcworkspace), select the `app` scheme, and run on an iOS 26+ simulator

---

## Demo

**1. Run the app**
- (If not enabled, enable system navigation in the settings)
- Navigate tabs → native liquid glass tab bar
- Tap a session → native push transition + back gesture
- _"This is a KMP app. Let me show you how it's wired up."_

**2. Swift entry point** — [`ContentView.swift`](app/iosApp/src/ContentView.swift)
- Branches on iOS 26+: `NativeNavContentView` vs full-screen `ComposeView` fallback
- `NativeNavContentView` is a SwiftUI `TabView` — the tab bar is drawn by SwiftUI, not Compose
- Navigation callbacks (`onNavigate`, `onGoBack`, ...) pass routing decisions up to Swift

**3. Kotlin entry point** — [`kotlinconf/main.ios.kt`](app/shared/src@ios/org/jetbrains/kotlinconf/main.ios.kt)
- `MainViewController(topLevelRoute:onNavigate:onGoBack:...)` — Compose calls these lambdas instead of doing its own navigation
- _"This is all the Kotlin side needs — a `ComposeUIViewController` wrapping a `@Composable`"_

**4. Key highlights** — back in [`ContentView.swift`](app/iosApp/src/ContentView.swift)
- `.tabBarMinimizeBehavior(.automatic)` — liquid glass collapse on scroll, free
- _"None of the animation or chrome code lives in Kotlin. Compose just renders content."_

---

## Key Q&As

**"Why not just use Compose for everything?"**
You can! But native navigation gives you platform behaviors (system gestures, sheet detents) that are hard to replicate. Pick the right tool per layer.

**"Can you do glass effects purely in Compose?"**
Yes — see [KMPLiquidGlass](https://github.com/Kashif-E/KMPLiquidGlass). More control, but you own the animations.

**"Are there libraries for adaptive/native-feeling Compose UIs?"**
[Calf](https://klibs.io/project/MohamedRejeb/Calf) — adaptive components (sheets, pickers, file pickers) that wrap native platform UI from Compose.

---

**Related documentation**: [kotl.in/liquid-glass](https://kotl.in/liquid-glass)
