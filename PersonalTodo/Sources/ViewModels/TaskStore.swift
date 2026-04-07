import Foundation
import SwiftData
import Observation

@Observable
final class TaskStore {
    static var shared: TaskStore?

    var tasks: [TodoTask] = []
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        refresh()
    }

    func refresh() {
        let descriptor = FetchDescriptor<TodoTask>(sortBy: [SortDescriptor(\.sortOrder)])
        tasks = (try? modelContext.fetch(descriptor)) ?? []
    }

    var incompleteTasks: [TodoTask] {
        tasks.filter { !$0.completed }
    }

    var overdueTasks: [TodoTask] {
        incompleteTasks.filter { !Calendar.current.isDateInToday($0.createdDate) }
    }

    var existingLabels: [String] {
        let labels = Set(tasks.map(\.label)).filter { !$0.isEmpty }
        return labels.sorted()
    }

    func addTask(title: String, label: String) {
        guard !title.isEmpty else { return }
        let maxOrder = tasks.map(\.sortOrder).max() ?? -1
        let task = TodoTask(title: title, label: label, sortOrder: maxOrder + 1)
        modelContext.insert(task)
        try? modelContext.save()
        refresh()
    }

    func completeTask(_ task: TodoTask) {
        task.completed = true
        try? modelContext.save()
        refresh()
    }

    func moveTaskToToday(_ task: TodoTask) {
        task.createdDate = Date()
        try? modelContext.save()
        refresh()
    }

    func swapTasks(_ indexA: Int, _ indexB: Int) {
        var mutable = incompleteTasks
        guard indexA >= 0, indexB >= 0, indexA < mutable.count, indexB < mutable.count else { return }
        mutable.swapAt(indexA, indexB)
        for (index, t) in mutable.enumerated() {
            t.sortOrder = index
        }
        try? modelContext.save()
        refresh()
    }
}
