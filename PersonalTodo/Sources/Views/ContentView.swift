import SwiftUI

struct ContentView: View {
    let store: TaskStore
    @State private var appState = AppState()

    var body: some View {
        Group {
            if appState.needsMorningReview(overdueCount: store.overdueTasks.count) {
                MorningReviewView(store: store) {
                    appState.completeMorningReview()
                    store.refresh()
                }
            } else {
                VStack(spacing: 0) {
                    TaskListView(store: store)
                    Divider()
                    AddTaskView(store: store)
                    Divider()
                    AppFooter()
                }
            }
        }
        .frame(width: 340, height: 450)
        .onAppear {
            store.refresh()
            if appState.isNewDay && !store.overdueTasks.isEmpty {
                NotificationService.sendMorningReminder(taskCount: store.overdueTasks.count)
            }
        }
    }
}
