import UIKit

final class Commons {
    static let shared = Commons()
    private init() {}
    
    let screenHeight = UIScreen.main.bounds.height
}
