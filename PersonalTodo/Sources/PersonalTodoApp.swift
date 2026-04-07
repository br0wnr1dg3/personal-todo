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

    init() {
        NotificationService.requestPermission()
    }
}
