# Demo 05: Swift Export

**Goal**: Show generated, idiomatic Swift APIs from Kotlin — no manual wrappers.

**Time**: ~8 min | **Reset**: No

---

## Setup

- IntelliJ: open `repos/05-swift-export/`, let Gradle sync (note this is not a Kotlin Toolchain project)
- Xcode: open `iosApp/iosApp.xcodeproj`, **run the app once** to trigger code generation

---

## Demo

1. **Run the app** — each line on screen calls Kotlin code

2. **[`ContentView.swift`](iosApp/iosApp/ContentView.swift)** — show call sites:
   - `useClassFromA()` / `useClassFromB()` → Kotlin modules = Swift modules
   - `await vm.loadUsers()` → `suspend` = `async`
   - `for try await user in vm.users` → `Flow` = `AsyncSequence`

3. **[`SuspendExample.kt`](shared/src/commonMain/kotlin/com/github/jetbrains/swiftexport/SuspendExample.kt)** — show `suspend fun loadUsers()` and `val users: Flow<User>`:

4. **[`Common.kt`](shared/src/commonMain/kotlin/com/github/jetbrains/swiftexport/Common.kt)** — show a few highlights (type aliases, extension functions, overloads):

5. **[`EnumDemonstration.kt`](shared/src/commonMain/kotlin/com/github/jetbrains/swiftexport/EnumDemonstration.kt)** — show the enum class with properties:
   - `enum class EnumDemonstration(var i: Int, ...)` — enum with mutable property
   - In Swift: `switch e { case .FirstCase: e.i }` — case matching and property access, no boilerplate
6. **[`TypeSystemImprovements.kt`](shared/src/commonMain/kotlin/com/github/jetbrains/swiftexport/TypeSystemImprovements.kt)** — show nested enum + generic function:
   - `fun <T> checkType(input: T): ReceivedType` — generic function returning an enum
   - Comment: `// crash at runtime before 2.4.0` — highlight the 2.4.0 fix
7. **Generated output** — [`shared/build/SwiftExport/iosSimulatorArm64/Debug/files/Shared/Shared.swift`](shared/build/SwiftExport/iosSimulatorArm64/Debug/files/Shared/Shared.swift):
   - No Obj-C, no `KotlinUnit`, looks like hand-written Swift
   - Find the `EnumDemonstration` enum — show `CaseIterable`, `RawRepresentable` conformances generated automatically

8. **Supported features**: https://kotl.in/swift-export-features-2-4-0

---

## Q&A

**"Is it production-ready?"** — Alpha. Goal here is feedback and early adopters.

**"When stable?"** — No date yet, actively in development.

**"Already using KMP-NativeCoroutines?"** — There's a migration guide: https://github.com/rickclephas/KMP-NativeCoroutines/blob/master/SWIFT_EXPORT.md
