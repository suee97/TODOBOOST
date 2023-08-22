import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func getScheduleInfo(completion: @escaping (APIResult, [Schedule]?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            completion(.success,
                       [
                        Schedule(id: 0, day: 22, title: "알고리즘 문제풀이", category: "Algorithm", isPushNotification: false, notificationTime: "", isImportant: false, isDone: false),
                        Schedule(id: 1, day: 22, title: "친구랑 게임하기", category: "Etc", isPushNotification: true, notificationTime: "", isImportant: false, isDone: false),
                        Schedule(id: 2, day: 22, title: "공부하기", category: "Study", isPushNotification: false, notificationTime: "", isImportant: false, isDone: false),
                        Schedule(id: 3, day: 22, title: "면접보러가기", category: "Study", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 4, day: 22, title: "친구 만나기", category: "Etc", isPushNotification: true, notificationTime: "", isImportant: false, isDone: false),
                        Schedule(id: 5, day: 22, title: "블로그 글쓰기", category: "Etc", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 6, day: 22, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 7, day: 22, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 8, day: 22, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 9, day: 26, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 9, day: 26, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 9, day: 26, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 9, day: 26, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 9, day: 26, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                        Schedule(id: 9, day: 26, title: "빨래 하기!", category: "집안일", isPushNotification: false, notificationTime: "", isImportant: false, isDone: true),
                       ]
            )
        })
    }
}
