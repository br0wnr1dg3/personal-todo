import SwiftUI
import ServiceManagement

struct AppFooter: View {
    @State private var launchOnLogin = SMAppService.mainApp.status == .enabled
    @State private var reminderEnabled = NotificationService.reminderEnabled
    @State private var reminderTime = NotificationService.reminderTime

    var body: some View {
        VStack(spacing: 6) {
            // Daily reminder row
            HStack {
                Toggle("Daily reminder", isOn: $reminderEnabled)
                    .toggleStyle(.switch)
                    .controlSize(.mini)
                    .onChange(of: reminderEnabled) { _, newValue in
                        NotificationService.reminderEnabled = newValue
                    }

                Spacer()

                if reminderEnabled {
                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .controlSize(.mini)
                        .frame(width: 80)
                        .onChange(of: reminderTime) { _, newValue in
                            NotificationService.reminderTime = newValue
                        }
                }
            }

            // Launch on login + quit row
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
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}
