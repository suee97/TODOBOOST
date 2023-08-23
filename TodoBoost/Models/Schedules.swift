import Foundation

struct Schedules: Codable {
    let schedules: [Schedule]
    let categoryInfo: CategoryInfo
}

struct Schedule: Codable {
    let id: Int
    let date: String
    let title: String
    let isNoti: Bool
    let notiTime: String
    let isImportant: Bool
    let isDone: Bool
    let schedulePriority: Int
}

struct CategoryInfo: Codable {
    let category: String
    let categoryPriority: Int
}
