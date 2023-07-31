import Foundation

struct Schedule: Codable {
    let id: Int
    let day: Int
    let title: String
    let category: String
    let isPushNotification: Bool
    let notificationTime: String
    let isImportant: Bool
    let isDone: Bool
}
