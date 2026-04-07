import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allTasks: [TodoTask]

    @State private var title = ""
    @State private var label = ""
    @State private var showLabelSuggestions = false

    private var existingLabels: [String] {
        let labels = Set(allTasks.map(\.label)).filter { !$0.isEmpty }
        return labels.sorted()
    }

    private var filteredLabels: [String] {
        if label.isEmpty { return existingLabels }
        return existingLabels.filter { $0.localizedCaseInsensitiveContains(label) }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Label suggestions
            if showLabelSuggestions && !filteredLabels.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(filteredLabels, id: \.self) { suggestion in
                            Button(suggestion) {
                                label = suggestion
                                showLabelSuggestions = false
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.quaternary)
                            .clipShape(Capsule())
                            .font(.caption)
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }

            HStack(spacing: 8) {
                TextField("Label", text: $label)
                    .textFieldStyle(.plain)
                    .frame(width: 80)
                    .padding(6)
                    .background(.quaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .font(.caption)
                    .onTapGesture { showLabelSuggestions = true }

                TextField("New task...", text: $title)
                    .textFieldStyle(.plain)
                    .padding(6)
                    .background(.quaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .onSubmit(addTask)

                Button(action: addTask) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .disabled(title.isEmpty)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    private func addTask() {
        guard !title.isEmpty else { return }
        let maxOrder = allTasks.map(\.sortOrder).max() ?? -1
        let task = TodoTask(title: title, label: label, sortOrder: maxOrder + 1)
        modelContext.insert(task)
        title = ""
        showLabelSuggestions = false
    }
}
