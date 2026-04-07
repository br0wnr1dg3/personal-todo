import UserNotifications

struct NotificationService {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func sendMorningReminder(taskCount: Int) {
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
