// MARK: Combine + @Published

import Foundation
import Combine

final class MonthViewModel {
    
    var today: StringDate!
    var categories = [String]()
    
    @Published var loadingState: LoadingState!
    @Published var schedules: [[Schedule]] = Array(repeating: [Schedule](), count: 32)
    @Published var selectedDay: StringDate!
    
    init() {
        let todayDate = Date()
        let dateString = getStringDateFromDate(of: todayDate)
        selectedDay = dateString
        today = dateString
        
        loadingState = .loading
        print("MonthViewModel init() - selectedDay: \(selectedDay)")
    }
    
    func getScheduleInfo() {
        print("MonthViewModel - getScheduleInfo() called")
        
        NetworkService.shared.getScheduleInfo(completion: { res, data in

            // fetch month data
            if res == .success {
                var tmp: [[Schedule]] = Array(repeating: [Schedule](), count: 32)
                guard let data = data else { return }
                self.categories = data.categories
                for e in data.schedules {
                    tmp[Int(e.date.suffix(2))!].append(e)
                }
                
                for i in 1...31 {
                    tmp[i].sort {
                        if $0.categoryIndex == $1.categoryIndex {
                            return $0.priority < $1.priority
                        }
                        return $0.categoryIndex < $1.categoryIndex
                    }
                }
                
                self.schedules = tmp
            }

            // set loading state
            self.loadingState = .done
        })
    }
    
    func appendEmptySchedule(to category: String, stringDate: StringDate) {
        guard let categoryIndex = categories.firstIndex(of: category) else { return }
        var maxPriority: Int = -1
        
        for e in schedules[stringDate.day] {
            if e.categoryIndex == categoryIndex {
                maxPriority = max(maxPriority, e.priority)
            }
        }
        maxPriority += 1
        
        schedules[stringDate.day].append(Schedule(categoryIndex: categoryIndex, priority: maxPriority, id: UUID().hashValue, date: "\(stringDate.year)-\(stringDate.month)-\(stringDate.day)", title: "", isNoti: false, notiTime: "", isImportant: false, isDone: false))
        
        sortSchedule(stringDate: stringDate)
    }
    
    func sortSchedule(stringDate: StringDate) {
        schedules[stringDate.day].sort {
            if $0.categoryIndex == $1.categoryIndex {
                return $0.priority < $1.priority
            }
            return $0.categoryIndex < $1.categoryIndex
        }
    }
    
    func updateSchedule(id: Int, schedule: Schedule) {
        for i in 0..<schedules[selectedDay.day].count {
            if schedules[selectedDay.day][i].id == id {
                schedules[selectedDay.day][i] = schedule
            }
        }
    }
    
    func deleteSchedule(id: Int) {
        for i in 0..<schedules[selectedDay.day].count {
            if schedules[selectedDay.day][i].id == id {
                schedules[selectedDay.day].remove(at: i)
                return
            }
        }
    }
    
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
    
    func getMemo() -> String {
        let string: String? = UserDefaults.standard.string(forKey: "memo")
        guard let memo = string, !memo.isEmpty else {
            return "메모를 입력하세요."
        }
        return memo
    }
    
    func setMemo(_ memo: String) {
        UserDefaults.standard.set(memo, forKey: "memo")
    }
    
    func initialize() {
        schedules = []
    }
}
