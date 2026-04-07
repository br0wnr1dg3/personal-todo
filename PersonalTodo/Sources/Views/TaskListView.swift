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
                List {
                    ForEach(store.incompleteTasks) { task in
                        TaskRow(task: task) {
                            store.completeTask(task)
                        }
                    }
                    .onMove { source, destination in
                        store.moveTasks(from: source, to: destination)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
