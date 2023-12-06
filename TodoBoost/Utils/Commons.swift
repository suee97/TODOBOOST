import UIKit

final class Commons {
    static let shared = Commons()
    private init() {}
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    func getStringDateFromDate(of date: Date) -> StringDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.string(from: date)
        let year = Int(date[date.startIndex..<date.index(date.startIndex, offsetBy: 4)])!
        let month = Int(date[date.index(date.startIndex, offsetBy: 4)..<date.index(date.startIndex, offsetBy: 6)])!
        let day = Int(date[date.index(date.startIndex, offsetBy: 6)..<date.index(date.startIndex, offsetBy: 8)])!
        let stringDate = StringDate(year: year, month: month, day: day)
        return stringDate
    }
    
    // local push notification
    let userNotiCenter = UNUserNotificationCenter.current()
    
    func requestAuthNoti() {
        let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotiCenter.requestAuthorization(options: notiAuthOptions) { (success, error) in
            if let error = error {
                print(#function, error)
            }
        }
    }
    
    func requestSendNoti(title: String, body: String, seconds: Int) {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = title
        notiContent.body = body
        notiContent.userInfo = ["targetScene": "splash"] // 푸시 받을때 오는 데이터
        
        // 알림이 trigger되는 시간 설정
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notiContent,
            trigger: trigger
        )
        
        userNotiCenter.add(request) { (error) in
            print(#function, error)
        }
        
    }
}
