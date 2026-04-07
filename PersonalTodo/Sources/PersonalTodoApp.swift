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
        // Hide dock icon — LSUIElement in Info.plist doesn't apply to SPM executables,
        // so we set it programmatically.
        NSApplication.shared.setActivationPolicy(.accessory)
        NotificationService.requestPermission()
    }
}
