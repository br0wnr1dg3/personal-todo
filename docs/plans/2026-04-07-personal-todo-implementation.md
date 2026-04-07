# Personal Todo Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a macOS menubar-only SwiftUI app for managing daily tasks with client labels, drag-to-reorder, and a morning review flow.

**Architecture:** A menubar app using `MenuBarExtra` with a popover. SwiftData for persistence. The app has two modes: Morning Review (clear yesterday's leftovers) and Today's Tasks (main view). State is managed via a single `@Observable` view model.

**Tech Stack:** SwiftUI, SwiftData, SMAppService, UserNotifications, macOS 14+

---

### Task 1: Create Xcode Project

**Step 1: Create the Swift Package / Xcode project**

Create a new macOS App project using SwiftUI.

Run:
```bash
cd /Users/christopherbrownridge/Desktop/projects/personal-todo
mkdir -p PersonalTodo/PersonalTodo
```

**Step 2: Create the Xcode project file**

Create: `PersonalTodo/PersonalTodo.xcodeproj` via Xcode CLI or manually.

Simpler approach — create a Swift Package-based app. Create these files:

Create: `PersonalTodo/Package.swift`
```swift
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "PersonalTodo",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "PersonalTodo",
            path: "Sources"
        )
    ]
)
```

Create: `PersonalTodo/Sources/PersonalTodoApp.swift`
```swift
import SwiftUI
import SwiftData

@main
struct PersonalTodoApp: App {
    var body: some Scene {
        MenuBarExtra("Personal Todo", systemImage: "checklist") {
            Text("Hello, Todo!")
                .padding()
        }
        .menuBarExtraStyle(.window)
    }
}
```

**Step 3: Verify it builds**

Run:
```bash
cd /Users/christopherbrownridge/Desktop/projects/personal-todo/PersonalTodo
swift build
```
Expected: Build succeeds.

**Step 4: Commit**

```bash
git add PersonalTodo/
git commit -m "feat: scaffold menubar app with SwiftUI"
```

---

### Task 2: Data Model

**Files:**
- Create: `PersonalTodo/Sources/Models/TodoTask.swift`

**Step 1: Create the SwiftData model**

Create: `PersonalTodo/Sources/Models/TodoTask.swift`
```swift
import Foundation
import SwiftData

@Model
final class TodoTask {
    var id: UUID
    var title: String
    var label: String
    var createdDate: Date
    var completed: Bool
    var sortOrder: Int

    init(title: String, label: String, sortOrder: Int = 0) {
        self.id = UUID()
        self.title = title
        self.label = label
        self.createdDate = Date()
        self.completed = false
        self.sortOrder = sortOrder
    }
}
```

**Step 2: Wire up SwiftData container in the app**

Modify: `PersonalTodo/Sources/PersonalTodoApp.swift`
```swift
import SwiftUI
import SwiftData

@main
struct PersonalTodoApp: App {
    var body: some Scene {
        MenuBarExtra("Personal Todo", systemImage: "checklist") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
        .modelContainer(for: TodoTask.self)
    }
}
```

Create: `PersonalTodo/Sources/Views/ContentView.swift`
```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(filter: #Predicate<TodoTask> { !$0.completed },
           sort: \TodoTask.sortOrder)
    private var tasks: [TodoTask]

    var body: some View {
        VStack {
            Text("Tasks: \(tasks.count)")
        }
        .frame(width: 320, height: 400)
    }
}
```

**Step 3: Verify it builds**

Run:
```bash
cd /Users/christopherbrownridge/Desktop/projects/personal-todo/PersonalTodo
swift build
```
Expected: Build succeeds.

**Step 4: Commit**

```bash
git add PersonalTodo/Sources/
git commit -m "feat: add TodoTask SwiftData model and container"
```

---

### Task 3: Today's Tasks View

**Files:**
- Create: `PersonalTodo/Sources/Views/TaskRow.swift`
- Create: `PersonalTodo/Sources/Views/TaskListView.swift`
- Modify: `PersonalTodo/Sources/Views/ContentView.swift`

**Step 1: Create TaskRow**

Create: `PersonalTodo/Sources/Views/TaskRow.swift`
```swift
import SwiftUI

struct TaskRow: View {
    let task: TodoTask
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onToggle) {
                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.completed ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .strikethrough(task.completed)
                    .foregroundStyle(task.completed ? .secondary : .primary)
                if !task.label.isEmpty {
                    Text(task.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .background(.quaternary)
                        .clipShape(Capsule())
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
}
```

**Step 2: Create TaskListView**

Create: `PersonalTodo/Sources/Views/TaskListView.swift`
```swift
import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<TodoTask> { !$0.completed },
           sort: \TodoTask.sortOrder)
    private var tasks: [TodoTask]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Today")
                    .font(.headline)
                Spacer()
                Text("\(tasks.count) tasks")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            // Task list
            if tasks.isEmpty {
                Spacer()
                Text("No tasks for today")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(tasks) { task in
                        TaskRow(task: task) {
                            task.completed = true
                        }
                    }
                    .onMove { source, destination in
                        var mutableTasks = tasks
                        mutableTasks.move(fromOffsets: source, toOffset: destination)
                        for (index, task) in mutableTasks.enumerated() {
                            task.sortOrder = index
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
```

**Step 3: Update ContentView to use TaskListView**

Modify: `PersonalTodo/Sources/Views/ContentView.swift`
```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            TaskListView()
            Divider()
            AddTaskView()
        }
        .frame(width: 340, height: 450)
    }
}
```

Note: `AddTaskView` is created in the next task — stub it for now if needed to build.

**Step 4: Verify it builds**

Run: `swift build`
Expected: Build succeeds (may need AddTaskView stub).

**Step 5: Commit**

```bash
git add PersonalTodo/Sources/
git commit -m "feat: add task list view with completion toggle and reorder"
```

---

### Task 4: Add Task View (with Label Picker)

**Files:**
- Create: `PersonalTodo/Sources/Views/AddTaskView.swift`

**Step 1: Create AddTaskView**

Create: `PersonalTodo/Sources/Views/AddTaskView.swift`
```swift
import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allTasks: [TodoTask]

    @State private var title = ""
    @State private var label = ""
    @State private var showLabelSuggestions = false

    private var existingLabels: [String] {
        let labels = Set(allTasks.map(\.label)).filter { !$0.isEmpty }
        return labels.sorted()
    }

    private var filteredLabels: [String] {
        if label.isEmpty { return existingLabels }
        return existingLabels.filter { $0.localizedCaseInsensitiveContains(label) }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Label suggestions
            if showLabelSuggestions && !filteredLabels.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(filteredLabels, id: \.self) { suggestion in
                            Button(suggestion) {
                                label = suggestion
                                showLabelSuggestions = false
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.quaternary)
                            .clipShape(Capsule())
                            .font(.caption)
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }

            HStack(spacing: 8) {
                TextField("Label", text: $label)
                    .textFieldStyle(.plain)
                    .frame(width: 80)
                    .padding(6)
                    .background(.quaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .font(.caption)
                    .onTapGesture { showLabelSuggestions = true }

                TextField("New task...", text: $title)
                    .textFieldStyle(.plain)
                    .padding(6)
                    .background(.quaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .onSubmit(addTask)

                Button(action: addTask) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .disabled(title.isEmpty)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    private func addTask() {
        guard !title.isEmpty else { return }
        let maxOrder = allTasks.map(\.sortOrder).max() ?? -1
        let task = TodoTask(title: title, label: label, sortOrder: maxOrder + 1)
        modelContext.insert(task)
        title = ""
        showLabelSuggestions = false
    }
}
```

**Step 2: Verify it builds**

Run: `swift build`
Expected: Build succeeds.

**Step 3: Commit**

```bash
git add PersonalTodo/Sources/Views/AddTaskView.swift
git commit -m "feat: add task creation with label picker"
```

---

### Task 5: Morning Review View

**Files:**
- Create: `PersonalTodo/Sources/Views/MorningReviewView.swift`
- Create: `PersonalTodo/Sources/ViewModels/AppState.swift`
- Modify: `PersonalTodo/Sources/Views/ContentView.swift`

**Step 1: Create AppState to track morning review logic**

Create: `PersonalTodo/Sources/ViewModels/AppState.swift`
```swift
import Foundation
import SwiftData
import Observation

@Observable
final class AppState {
    var morningReviewComplete = false

    private let lastActiveDateKey = "lastActiveDate"

    var isNewDay: Bool {
        guard let lastDate = UserDefaults.standard.object(forKey: lastActiveDateKey) as? Date else {
            return true
        }
        return !Calendar.current.isDateInToday(lastDate)
    }

    func markDayActive() {
        UserDefaults.standard.set(Date(), forKey: lastActiveDateKey)
    }

    func needsMorningReview(overdueCount: Int) -> Bool {
        return isNewDay && overdueCount > 0 && !morningReviewComplete
    }

    func completeMorningReview() {
        morningReviewComplete = true
        markDayActive()
    }
}
```

**Step 2: Create MorningReviewView**

Create: `PersonalTodo/Sources/Views/MorningReviewView.swift`
```swift
import SwiftUI
import SwiftData

struct MorningReviewView: View {
    @Environment(\.modelContext) private var modelContext
    let overdueTasks: [TodoTask]
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 4) {
                Image(systemName: "sunrise.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                Text("Morning Review")
                    .font(.headline)
                Text("\(overdueTasks.count) tasks from previous days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)

            Divider()

            // Task list
            List {
                ForEach(overdueTasks) { task in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.title)
                            if !task.label.isEmpty {
                                Text(task.label)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        Button("Done") {
                            task.completed = true
                            checkIfComplete()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .controlSize(.small)

                        Button("Today") {
                            task.createdDate = Date()
                            checkIfComplete()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                    .padding(.vertical, 2)
                }
            }
            .listStyle(.plain)
        }
    }

    private func checkIfComplete() {
        let remaining = overdueTasks.filter { !$0.completed && !Calendar.current.isDateInToday($0.createdDate) }
        if remaining.isEmpty {
            onComplete()
        }
    }
}
```

**Step 3: Update ContentView to route between views**

Modify: `PersonalTodo/Sources/Views/ContentView.swift`
```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<TodoTask> { !$0.completed },
           sort: \TodoTask.sortOrder)
    private var incompleteTasks: [TodoTask]

    @State private var appState = AppState()

    private var overdueTasks: [TodoTask] {
        incompleteTasks.filter { !Calendar.current.isDateInToday($0.createdDate) }
    }

    var body: some View {
        Group {
            if appState.needsMorningReview(overdueCount: overdueTasks.count) {
                MorningReviewView(overdueTasks: overdueTasks) {
                    appState.completeMorningReview()
                }
            } else {
                VStack(spacing: 0) {
                    TaskListView()
                    Divider()
                    AddTaskView()
                }
            }
        }
        .frame(width: 340, height: 450)
    }
}
```

**Step 4: Verify it builds**

Run: `swift build`
Expected: Build succeeds.

**Step 5: Commit**

```bash
git add PersonalTodo/Sources/
git commit -m "feat: add morning review flow for overdue tasks"
```

---

### Task 6: Morning Notification & Auto-Open Popover

**Files:**
- Create: `PersonalTodo/Sources/Services/NotificationService.swift`
- Modify: `PersonalTodo/Sources/PersonalTodoApp.swift`

**Step 1: Create NotificationService**

Create: `PersonalTodo/Sources/Services/NotificationService.swift`
```swift
import UserNotifications

struct NotificationService {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func sendMorningReminder(taskCount: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Morning Review"
        content.body = "You have \(taskCount) task\(taskCount == 1 ? "" : "s") to review"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "morning-review",
            content: content,
            trigger: nil // Deliver immediately
        )
        UNUserNotificationCenter.current().add(request)
    }
}
```

**Step 2: Update app entry point for notification and auto-open**

Modify: `PersonalTodo/Sources/PersonalTodoApp.swift`

```swift
import SwiftUI
import SwiftData

@main
struct PersonalTodoApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        MenuBarExtra("Personal Todo", systemImage: "checklist") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
        .modelContainer(for: TodoTask.self)
    }

    init() {
        NotificationService.requestPermission()
    }
}
```

> **Note:** Auto-opening the popover programmatically from `MenuBarExtra` is limited in SwiftUI. The notification serves as the primary nudge. The popover opens on click. If we find a way to programmatically open it (e.g., via `NSStatusItem` directly), we can add that as a refinement.

**Step 3: Verify it builds**

Run: `swift build`
Expected: Build succeeds.

**Step 4: Commit**

```bash
git add PersonalTodo/Sources/
git commit -m "feat: add morning notification for overdue tasks"
```

---

### Task 7: Launch on Login

**Files:**
- Modify: `PersonalTodo/Sources/PersonalTodoApp.swift`

**Step 1: Add launch-on-login toggle**

> **Important:** `SMAppService` requires the app to be in `/Applications` or signed. For development, we'll add the UI and code, but it only works when the app is properly installed. This is standard macOS behavior.

Modify: `PersonalTodo/Sources/PersonalTodoApp.swift` — add a settings view or a small toggle in the popover footer.

For simplicity, add it directly in the main ContentView footer area:

Create: `PersonalTodo/Sources/Views/AppFooter.swift`
```swift
import SwiftUI
import ServiceManagement

struct AppFooter: View {
    @State private var launchOnLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        HStack {
            Toggle("Launch on login", isOn: $launchOnLogin)
                .toggleStyle(.switch)
                .controlSize(.mini)
                .onChange(of: launchOnLogin) { _, newValue in
                    do {
                        if newValue {
                            try SMAppService.mainApp.register()
                        } else {
                            try SMAppService.mainApp.unregister()
                        }
                    } catch {
                        launchOnLogin = !newValue
                    }
                }

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}
```

**Step 2: Add footer to ContentView**

Modify `ContentView.swift` — add `AppFooter()` below `AddTaskView()`:
```swift
VStack(spacing: 0) {
    TaskListView()
    Divider()
    AddTaskView()
    Divider()
    AppFooter()
}
```

**Step 3: Verify it builds**

Run: `swift build`
Expected: Build succeeds.

**Step 4: Commit**

```bash
git add PersonalTodo/Sources/
git commit -m "feat: add launch on login toggle and quit button"
```

---

### Task 8: Badge on Menubar Icon

**Files:**
- Modify: `PersonalTodo/Sources/PersonalTodoApp.swift`

**Step 1: Switch from systemImage to custom label for badge support**

To show a badge/count on the menubar icon, we need to use `MenuBarExtra` with a custom label. SwiftUI's `MenuBarExtra` with `.window` style supports custom labels:

Modify: `PersonalTodo/Sources/PersonalTodoApp.swift`
```swift
import SwiftUI
import SwiftData

@main
struct PersonalTodoApp: App {
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            MenuBarLabel()
        }
        .menuBarExtraStyle(.window)
        .modelContainer(for: TodoTask.self)
    }

    init() {
        NotificationService.requestPermission()
    }
}
```

Create: `PersonalTodo/Sources/Views/MenuBarLabel.swift`
```swift
import SwiftUI
import SwiftData

struct MenuBarLabel: View {
    @Query(filter: #Predicate<TodoTask> { !$0.completed })
    private var incompleteTasks: [TodoTask]

    private var overdueCount: Int {
        incompleteTasks.filter { !Calendar.current.isDateInToday($0.createdDate) }.count
    }

    var body: some View {
        if overdueCount > 0 {
            Label("\(overdueCount)", systemImage: "checklist")
        } else {
            Label("Todo", systemImage: "checklist")
        }
    }
}
```

> **Note:** The menubar label in SwiftUI is limited — it may show as text + icon. The count next to the icon serves as the "badge."

**Step 2: Trigger notification on app become active if new day**

Add notification trigger logic. Modify `ContentView.swift` to fire notification on appear:

Add to ContentView body:
```swift
.onAppear {
    if appState.isNewDay && !overdueTasks.isEmpty {
        NotificationService.sendMorningReminder(taskCount: overdueTasks.count)
    }
}
```

**Step 3: Verify it builds**

Run: `swift build`
Expected: Build succeeds.

**Step 4: Commit**

```bash
git add PersonalTodo/Sources/
git commit -m "feat: add overdue count badge to menubar icon"
```

---

### Task 9: Hide Dock Icon

**Files:**
- Create: `PersonalTodo/Sources/Info.plist` (or add to build settings)

**Step 1: Configure as agent app (no dock icon)**

For a Swift Package executable, we need to set `LSUIElement` to `true`. The cleanest way:

Create: `PersonalTodo/Sources/Info.plist`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
```

> **Note:** For Swift Package Manager executables, applying Info.plist requires building as a `.app` bundle. If `swift build` doesn't produce a `.app`, we'll need a simple shell script or Makefile to assemble the bundle. This task may need adjustment during implementation.

**Step 2: Verify it builds**

Run: `swift build`
Expected: Build succeeds.

**Step 3: Commit**

```bash
git add PersonalTodo/Sources/Info.plist
git commit -m "feat: hide dock icon with LSUIElement"
```

---

### Task 10: Polish & Manual Test

**Step 1: Build and run the app**

```bash
cd /Users/christopherbrownridge/Desktop/projects/personal-todo/PersonalTodo
swift build
.build/debug/PersonalTodo
```

**Step 2: Manual test checklist**

- [ ] Menubar icon appears
- [ ] Clicking icon opens popover
- [ ] Can add a task with a label
- [ ] Can check off a task
- [ ] Label suggestions appear for previously used labels
- [ ] Can type a new label
- [ ] Quit button works
- [ ] Relaunch — tasks persist
- [ ] Add a task, quit, change system date to tomorrow, relaunch — morning review appears
- [ ] Morning review: "Done" archives the task
- [ ] Morning review: "Today" moves task to today's list

**Step 3: Fix any issues found**

**Step 4: Final commit**

```bash
git add -A
git commit -m "feat: polish and fixes from manual testing"
```
