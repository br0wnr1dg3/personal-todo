import UserNotifications

struct NotificationService {
    /// Whether notifications are available (requires a proper .app bundle with a bundle identifier)
    private static var isAvailable: Bool {
        Bundle.main.bundleIdentifier != nil
    }

    static func requestPermission() {
        guard isAvailable else { return }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func sendMorningReminder(taskCount: Int) {
        guard isAvailable else { return }
        let content = UNMutableNotificationContent()
        content.title = "Morning Review"
        content.body = "You have \(taskCount) task\(taskCount == 1 ? "" : "s") to review"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "morning-review",
            content: content,
            trigger: nil // Deliver immediately
        )
        UNUserNotificationCenter.current().add(request)
    }
}
