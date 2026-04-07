import SwiftUI

struct MenuBarLabel: View {
    let store: TaskStore

    var body: some View {
        if store.overdueTasks.count > 0 {
            Label("\(store.overdueTasks.count)", systemImage: "checklist")
        } else {
            Label("Todo", systemImage: "checklist")
        }
    }
}
