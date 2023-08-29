import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func getScheduleInfo(completion: @escaping (APIResult, MonthSchedules?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            let res = MonthSchedules(categories: ["common", "study", "buy", "assignmnet"], schedules: [
                Schedule(categoryIndex: 1, priority: 0, id: 0, date: "2023-08-29", title: "공부하기 1", isNoti: false, notiTime: "", isImportant: true, isDone: false),
                Schedule(categoryIndex: 0, priority: 0, id: 1, date: "2023-08-29", title: "common 1", isNoti: false, notiTime: "", isImportant: true, isDone: false),
                Schedule(categoryIndex: 2, priority: 0, id: 2, date: "2023-08-29", title: "buy 1", isNoti: false, notiTime: "", isImportant: true, isDone: false),
                Schedule(categoryIndex: 1, priority: 1, id: 3, date: "2023-08-29", title: "공부하기 2", isNoti: false, notiTime: "", isImportant: true, isDone: false),
                Schedule(categoryIndex: 0, priority: 1, id: 4, date: "2023-08-29", title: "common 2", isNoti: false, notiTime: "", isImportant: true, isDone: false),
            ])
            
            completion(.success, res)
        })
    }
}
