import UserNotifications

struct NotificationService {
    private static let reminderTimeKey = "dailyReminderTime"
    private static let reminderEnabledKey = "dailyReminderEnabled"

    /// Whether notifications are available (requires a proper .app bundle with a bundle identifier)
    private static var isAvailable: Bool {
        Bundle.main.bundleIdentifier != nil
    }

    static func requestPermission() {
        guard isAvailable else { return }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // MARK: - Daily Reminder

    static var reminderEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: reminderEnabledKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: reminderEnabledKey)
            if newValue {
                scheduleDailyReminder(at: reminderTime)
            } else {
                cancelDailyReminder()
            }
        }
    }

    static var reminderTime: Date {
        get {
            if let saved = UserDefaults.standard.object(forKey: reminderTimeKey) as? Date {
                return saved
            }
            // Default: 7:45 AM
            var components = DateComponents()
            components.hour = 7
            components.minute = 45
            return Calendar.current.date(from: components) ?? Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: reminderTimeKey)
            if reminderEnabled {
                scheduleDailyReminder(at: newValue)
            }
        }
    }

    static func scheduleDailyReminder(at time: Date) {
        guard isAvailable else { return }

        let content = UNMutableNotificationContent()
        content.title = "Personal Todo"
        content.body = "Time to review and plan your tasks for today"
        content.sound = .default

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: time)
        dateComponents.minute = calendar.component(.minute, from: time)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "daily-reminder",
            content: content,
            trigger: trigger
        )

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])
        center.add(request)
    }

    static func cancelDailyReminder() {
        guard isAvailable else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])
    }

    // MARK: - Immediate Reminder (overdue tasks)

    static func sendMorningReminder(taskCount: Int) {
        guard isAvailable else { return }
        let content = UNMutableNotificationContent()
        content.title = "Morning Review"
        content.body = "You have \(taskCount) task\(taskCount == 1 ? "" : "s") to review"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "morning-review",
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
}
