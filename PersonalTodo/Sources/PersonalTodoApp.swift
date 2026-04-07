import SwiftUI
import SwiftData

@main
struct PersonalTodoApp: App {
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
        NotificationService.requestPermission()

        // Register URL scheme handler
        NSAppleEventManager.shared().setEventHandler(
            URLHandler.shared,
            andSelector: #selector(URLHandler.handleURL(_:withReply:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
        URLHandler.shared.store = store
    }
}
