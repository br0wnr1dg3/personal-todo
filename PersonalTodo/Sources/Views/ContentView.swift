import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(filter: #Predicate<TodoTask> { !$0.completed },
           sort: \TodoTask.sortOrder)
    private var tasks: [TodoTask]

    init() {}

    var body: some View {
        VStack {
            Text("Tasks: \(tasks.count)")
        }
        .frame(width: 320, height: 400)
    }
}
