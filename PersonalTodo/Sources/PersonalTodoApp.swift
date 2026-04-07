import SwiftUI
import SwiftData

@main
struct PersonalTodoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let container: ModelContainer
    @State private var store: TaskStore

    var body: some Scene {
        MenuBarExtra {
            ContentView(store: store)
        } label: {
            MenuBarLabel(store: store)
        }
        .menuBarExtraStyle(.window)
    }

    init() {
        let container = try! ModelContainer(for: TodoTask.self)
        self.container = container
        let store = TaskStore(modelContext: container.mainContext)
        self._store = State(initialValue: store)

        // Share store globally so AppDelegate can use it for URL handling
        TaskStore.shared = store

        NotificationService.requestPermission()
    }
}
