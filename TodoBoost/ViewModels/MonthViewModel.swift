// MARK: Combine + @Published

import Foundation
import Combine

final class MonthViewModel {
    
    var today: Date!
    
    @Published var loadingState: LoadingState!
    @Published var schedules: [[Schedule]] = Array(repeating: [], count: 32)
    @Published var selectedDay: Int!
    
    init() {
        let date = Date()
        today = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = Int(dateFormatter.string(from: date))!
        selectedDay = day
        
        loadingState = .loading
        
        print("MonthViewModel init() - selectedDay: \(selectedDay)")
    }
    
    func getScheduleInfo() {
        print("MonthViewModel - getScheduleInfo() called")
        NetworkService.shared.getScheduleInfo(completion: { res, data in

            // fetch month data
            if res == .success {
                guard let data = data else { return }
                var tmp: [[Schedule]] = Array(repeating: [], count: 32)
                for e in data {
                    let str = e.date.suffix(2)
                    tmp[Int(str)!].append(e)
                }
                self.schedules = tmp
            }

            // set loading state
            self.loadingState = .done
        })
    }
    
    func getDay(of date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = Int(dateFormatter.string(from: date))!
        return day
    }
}
