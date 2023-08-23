import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func getScheduleInfo(completion: @escaping (APIResult, [DaySchedules]?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            var tmp = Schedule(id: 0, title: "coding...", isNoti: false, notiTime: "", isImportant: true, isDone: true, priority: 0)
            
            var dic: [String: [Schedule]] = [
                "common" : [tmp, tmp, tmp, tmp],
                "study" : [tmp, tmp, tmp, tmp]
            ]
            
            var monthTmp: [DaySchedules] = [
                DaySchedules(date: "2023-08-01", schedules: dic),
                DaySchedules(date: "2023-08-02", schedules: dic),
                DaySchedules(date: "2023-08-03", schedules: dic),
                DaySchedules(date: "2023-08-04", schedules: dic),
                DaySchedules(date: "2023-08-05", schedules: dic),
                DaySchedules(date: "2023-08-06", schedules: dic),
                DaySchedules(date: "2023-08-07", schedules: dic),
                DaySchedules(date: "2023-08-08", schedules: dic),
                DaySchedules(date: "2023-08-09", schedules: dic),
                DaySchedules(date: "2023-08-10", schedules: dic),
                DaySchedules(date: "2023-08-11", schedules: dic),
                DaySchedules(date: "2023-08-12", schedules: dic),
                DaySchedules(date: "2023-08-13", schedules: dic),
                DaySchedules(date: "2023-08-14", schedules: dic),
                DaySchedules(date: "2023-08-15", schedules: dic),
                DaySchedules(date: "2023-08-16", schedules: dic),
                DaySchedules(date: "2023-08-17", schedules: dic),
                DaySchedules(date: "2023-08-18", schedules: dic),
                DaySchedules(date: "2023-08-19", schedules: dic),
                DaySchedules(date: "2023-08-20", schedules: dic),
                DaySchedules(date: "2023-08-21", schedules: dic),
                DaySchedules(date: "2023-08-22", schedules: dic),
                DaySchedules(date: "2023-08-23", schedules: dic),
                DaySchedules(date: "2023-08-24", schedules: dic),
                DaySchedules(date: "2023-08-25", schedules: dic),
                DaySchedules(date: "2023-08-26", schedules: dic),
                DaySchedules(date: "2023-08-27", schedules: dic),
                DaySchedules(date: "2023-08-28", schedules: dic),
                DaySchedules(date: "2023-08-29", schedules: dic),
                DaySchedules(date: "2023-08-30", schedules: dic),
                DaySchedules(date: "2023-08-31", schedules: dic)
            ]
            
            completion(.success, monthTmp)
        })
    }
}
