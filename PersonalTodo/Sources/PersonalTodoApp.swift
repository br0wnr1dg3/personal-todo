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
