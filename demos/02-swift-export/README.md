# Demo 02: Swift Export Alpha

**Goal**: Show generated, idiomatic Swift APIs from Kotlin — no manual wrappers.

**Time**: ~8 min | **Reset**: No

**Related KotlinConf 2026 talks**:
- [Swift Export: Where We Stand (May 21, 16:15–16:30)](https://kotlinconf.com/schedule/?day=2026-05-21&session=8ad5085d-1b01-5df1-aee2-edf629b20a50)
- [Can Kotlin Swift Interop Ever Be Perfect? (May 21, 16:45–17:00)](https://kotlinconf.com/schedule/?day=2026-05-21&session=20ecd656-1a63-567a-bb12-534756857433)

---

## Setup (done before demo)

- IntelliJ: open `repos/swift-export-sample/`, let Gradle sync
- Xcode: open `iosApp/iosApp.xcodeproj`, **run the app once** to trigger code generation

---

## Steps

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
