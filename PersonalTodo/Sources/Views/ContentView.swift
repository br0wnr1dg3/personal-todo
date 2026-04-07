import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            TaskListView()
        }
        .frame(width: 340, height: 450)
    }
}
