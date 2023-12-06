import Foundation

struct MonthSchedules: Codable {
    let categories: [String]
    let schedules: [Schedule]
}

struct Schedule: Codable {
    let categoryIndex: Int
    let priority: Int
    let id: Int
    let date: String
    var title: String
    let isNoti: Bool
    let notiTime: String
    let isImportant: Bool
    var isDone: Bool
}
