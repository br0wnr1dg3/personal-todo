import SwiftUI

struct TaskListView: View {
    let store: TaskStore
    @State private var draggingTask: TodoTask?

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
                        ForEach(store.incompleteTasks) { task in
                            TaskRow(task: task) {
                                store.completeTask(task)
                            }
                            .draggable(task.id.uuidString) {
                                TaskRow(task: task) {}
                                    .frame(width: 300)
                                    .opacity(0.8)
                            }
                            .dropDestination(for: String.self) { items, _ in
                                guard let draggedIdString = items.first,
                                      let draggedId = UUID(uuidString: draggedIdString),
                                      draggedId != task.id else { return false }
                                store.moveTask(id: draggedId, before: task)
                                return true
                            }
                            Divider().padding(.leading, 40)
                        }
                    }
                }
            }
        }
    }
}
