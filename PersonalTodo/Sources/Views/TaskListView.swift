import SwiftUI

struct TaskListView: View {
    let store: TaskStore

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Today")
                    .font(.headline)
                Spacer()
                Text("\(store.incompleteTasks.count) tasks")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            if store.incompleteTasks.isEmpty {
                Spacer()
                Text("No tasks for today")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(store.incompleteTasks.enumerated()), id: \.element.id) { index, task in
                            TaskRow(
                                task: task,
                                onToggle: { store.completeTask(task) },
                                onMoveUp: index > 0 ? { store.swapTasks(index, index - 1) } : nil,
                                onMoveDown: index < store.incompleteTasks.count - 1 ? { store.swapTasks(index, index + 1) } : nil
                            )
                            if index < store.incompleteTasks.count - 1 {
                                Divider().padding(.leading, 40)
                            }
                        }
                    }
                }
            }
        }
    }
}
