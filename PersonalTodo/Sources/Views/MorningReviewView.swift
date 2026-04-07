import SwiftUI
import SwiftData

struct MorningReviewView: View {
    @Environment(\.modelContext) private var modelContext
    let overdueTasks: [TodoTask]
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 4) {
                Image(systemName: "sunrise.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                Text("Morning Review")
                    .font(.headline)
                Text("\(overdueTasks.count) tasks from previous days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)

            Divider()

            // Task list
            List {
                ForEach(overdueTasks) { task in
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
                            task.completed = true
                            checkIfComplete()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .controlSize(.small)

                        Button("Today") {
                            task.createdDate = Date()
                            checkIfComplete()
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

    private func checkIfComplete() {
        let remaining = overdueTasks.filter { !$0.completed && !Calendar.current.isDateInToday($0.createdDate) }
        if remaining.isEmpty {
            onComplete()
        }
    }
}
