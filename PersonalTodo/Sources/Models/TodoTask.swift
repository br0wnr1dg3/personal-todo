import Foundation
import SwiftData

@Model
final class TodoTask {
    var id: UUID
    var title: String
    var label: String
    var createdDate: Date
    var completed: Bool
    var sortOrder: Int

    init(title: String, label: String, sortOrder: Int = 0) {
        self.id = UUID()
        self.title = title
        self.label = label
        self.createdDate = Date()
        self.completed = false
        self.sortOrder = sortOrder
    }
}
