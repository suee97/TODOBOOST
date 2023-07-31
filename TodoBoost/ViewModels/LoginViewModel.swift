// MARK: using Obeservable class

import Foundation

final class LoginViewModel {
    var loadingState: Observable<LoadingState>? = Observable(.loading)
    
    func autoLogin() {
        AuthService.shared.autoLogin(completion: { result in
            if (result == .success) {
                self.loadingState?.value = .done
            }
        })
    }
}

final class Observable<T> {
    var value: T {
        didSet {
            self.listener?(value)
        }
    }
    
    var listener: ((T) -> Void)?
    
    init (_ value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
