import UIKit
import Combine

final class Configuration {
    static let shared = Configuration()
    private init() {}
    
    // Theme Color
    @Published var themeColor: [String: UIColor] = [
        "primaryColor" : UIColor(red: 20/255, green: 10/255, blue: 38/255, alpha: 1),
        "secondaryColor" : UIColor(red: 34/255, green: 23/255, blue: 56/255, alpha: 1),
    ]
    
    @Published var importantScheduleTheme = TextTheme(font: UIFont.systemFont(ofSize: 18, weight: .semibold), color: .orange)
}

struct TextTheme {
    var font: UIFont
    var color: UIColor
}
