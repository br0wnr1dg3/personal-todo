import SwiftUI
import ServiceManagement

struct AppFooter: View {
    @State private var launchOnLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        HStack {
            Toggle("Launch on login", isOn: $launchOnLogin)
                .toggleStyle(.switch)
                .controlSize(.mini)
                .onChange(of: launchOnLogin) { _, newValue in
                    do {
                        if newValue {
                            try SMAppService.mainApp.register()
                        } else {
                            try SMAppService.mainApp.unregister()
                        }
                    } catch {
                        launchOnLogin = !newValue
                    }
                }

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}
