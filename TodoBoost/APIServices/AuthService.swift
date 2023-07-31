import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    func autoLogin(completion: @escaping (AuthResult) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            completion(.success)
        })
    }
}
