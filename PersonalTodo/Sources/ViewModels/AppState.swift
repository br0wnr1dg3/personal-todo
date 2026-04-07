import Foundation
import SwiftData
import Observation

@Observable
final class AppState {
    var morningReviewComplete = false

    private let lastActiveDateKey = "lastActiveDate"

    var isNewDay: Bool {
        guard let lastDate = UserDefaults.standard.object(forKey: lastActiveDateKey) as? Date else {
            return true
        }
        return !Calendar.current.isDateInToday(lastDate)
    }

    func markDayActive() {
        UserDefaults.standard.set(Date(), forKey: lastActiveDateKey)
    }

    func needsMorningReview(overdueCount: Int) -> Bool {
        return isNewDay && overdueCount > 0 && !morningReviewComplete
    }

    func completeMorningReview() {
        morningReviewComplete = true
        markDayActive()
    }
}
