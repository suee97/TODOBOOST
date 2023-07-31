import XCTest
@testable import TodoBoost

final class MonthVMTests: XCTestCase {
    
    var vm: MonthViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        vm = MonthViewModel()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        vm = nil
    }
    
}
