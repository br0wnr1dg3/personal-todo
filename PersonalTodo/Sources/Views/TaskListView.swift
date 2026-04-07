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
