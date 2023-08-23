import Foundation

struct Schedules: Codable {
    var schedules: [Schedule]
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
    let category: String
    let categoryPriority: Int
}
