import SwiftUI

struct AddTaskView: View {
    let store: TaskStore

    @State private var title = ""
    @State private var label = ""
    @State private var showLabelSuggestions = false

    private var filteredLabels: [String] {
        if label.isEmpty { return store.existingLabels }
        return store.existingLabels.filter { $0.localizedCaseInsensitiveContains(label) }
    }

    var body: some View {
        VStack(spacing: 8) {
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
        store.addTask(title: title, label: label)
        title = ""
        showLabelSuggestions = false
    }
}
