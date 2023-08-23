import Foundation

struct MonthSchedule: Codable {
    let monthSchedule: [DaySchedules]
}

struct DaySchedules: Codable {
    let date: String
    let schedules: [String: [Schedule]]
}

struct Schedule: Codable {
    let id: Int
    let title: String
    let isNoti: Bool
    let notiTime: String
    let isImportant: Bool
    let isDone: Bool
    let priority: Int
}
