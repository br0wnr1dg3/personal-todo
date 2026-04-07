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
                    Divider()
                    AppFooter()
                }
            }
        }
        .frame(width: 340, height: 450)
        .onAppear {
            if appState.isNewDay && !overdueTasks.isEmpty {
                NotificationService.sendMorningReminder(taskCount: overdueTasks.count)
            }
        }
    }
}
