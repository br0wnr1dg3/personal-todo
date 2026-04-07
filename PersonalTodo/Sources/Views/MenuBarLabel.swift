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
