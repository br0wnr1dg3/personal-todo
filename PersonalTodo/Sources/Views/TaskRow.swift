import SwiftUI

struct TaskRow: View {
    let task: TodoTask
    let onToggle: () -> Void
    var onMoveUp: (() -> Void)?
    var onMoveDown: (() -> Void)?

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onToggle) {
                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.completed ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .strikethrough(task.completed)
                    .foregroundStyle(task.completed ? .secondary : .primary)
                if !task.label.isEmpty {
                    Text(task.label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .background(.quaternary)
                        .clipShape(Capsule())
                }
            }

            Spacer()

            if onMoveUp != nil || onMoveDown != nil {
                VStack(spacing: 0) {
                    Button { onMoveUp?() } label: {
                        Image(systemName: "chevron.up")
                            .font(.caption2)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(onMoveUp != nil ? .secondary : .quaternary)
                    .disabled(onMoveUp == nil)

                    Button { onMoveDown?() } label: {
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(onMoveDown != nil ? .secondary : .quaternary)
                    .disabled(onMoveDown == nil)
                }
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
}
