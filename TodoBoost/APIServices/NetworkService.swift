import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func getScheduleInfo(completion: @escaping (APIResult, [Schedule]?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            completion(.success, [])
        })
    }
}
