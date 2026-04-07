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
