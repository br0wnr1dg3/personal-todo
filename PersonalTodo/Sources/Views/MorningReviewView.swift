import SwiftUI

struct MorningReviewView: View {
    let store: TaskStore
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Image(systemName: "sunrise.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                Text("Morning Review")
                    .font(.headline)
                Text("\(store.overdueTasks.count) tasks from previous days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)

            Divider()

            List {
                ForEach(store.overdueTasks) { task in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.title)
                            if !task.label.isEmpty {
                                Text(task.label)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        Button("Done") {
                            store.completeTask(task)
                            if store.overdueTasks.isEmpty {
                                onComplete()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .controlSize(.small)

                        Button("Today") {
                            store.moveTaskToToday(task)
                            if store.overdueTasks.isEmpty {
                                onComplete()
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                    .padding(.vertical, 2)
                }
            }
            .listStyle(.plain)
        }
    }
}
