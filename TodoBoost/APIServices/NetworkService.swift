import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func getScheduleInfo(completion: @escaping (APIResult, [Schedule]?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            var arr: [Schedule] = []
            
            for i in 0..<10 {
                let tmp = Schedule(id: i, date: "2023-08-23", title: "공부하기\(i)", isNoti: false, notiTime: "", isImportant: true, isDone: false, schedulePriority: i, category: "study", categoryPriority: i)
                arr.append(tmp)
            }
            
            completion(.success, arr)
        })
    }
}
