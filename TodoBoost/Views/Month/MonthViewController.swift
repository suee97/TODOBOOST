import UIKit
import SnapKit
import Combine
import FSCalendar

class MonthViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    private let viewModel = MonthViewModel()
    private var loadingSubscriber: AnyCancellable!
    private var daySubscriber: AnyCancellable!
    
    private let contentSideMargin: ConstraintInsetTarget = 16
    private let tableView = UITableView()

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryPurple
        return view
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TO DO BOOST"
        label.textColor = .white
        label.font = label.font.withSize(32)
        return label
    }()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(24)
        label.textColor = .white
        return label
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.style = .medium
        indicator.startAnimating()
        return indicator
    }()
    
    private let calendar: FSCalendar = {
        let divider = UIView()
        divider.backgroundColor = .secondaryWhite
        
        let calendar = FSCalendar()
        calendar.backgroundColor = .primaryPurple
        calendar.locale = Locale(identifier: "en")
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.placeholderType = .none
        calendar.appearance.selectionColor = .calendarSelected
        calendar.calendarWeekdayView.addSubview(divider)
        divider.snp.makeConstraints({m in
            m.left.right.equalTo(calendar.calendarWeekdayView)
            m.height.equalTo(1)
            m.top.equalTo(calendar.calendarWeekdayView.snp.bottom).offset(12)
        })
        calendar.collectionView.snp.makeConstraints({ m in
            m.top.equalTo(divider.snp.bottom).offset(15)
            m.left.right.bottom.equalTo(calendar)
        })
        calendar.calendarWeekdayView.weekdayLabels[0].text = "Su"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "Mo"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "Tu"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "We"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "Th"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "Fr"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "Sa"
        return calendar
    }()
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAllViewHide(true)
        indicator.startAnimating()
        viewModel.getScheduleInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpDelegate()
        configureUI()
        setUpSubscribers()
    }
    
    
    // MARK: UI
    private func configureUI() {
        view.backgroundColor = .primaryPurple
        isAllViewHide(true)
        
        view.addSubview(indicator)
        view.addSubview(tableView)
        headerView.addSubview(appNameLabel)
        headerView.addSubview(calendar)
        
        indicator.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
        
        tableView.snp.makeConstraints({ m in
            m.left.right.bottom.equalTo(view)
            m.top.equalTo(view.safeAreaLayoutGuide)
        })
        
        headerView.snp.makeConstraints({ m in
            m.width.equalTo(Commons.shared.screenWidth)
            m.height.equalTo(392)
        })
        
        appNameLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(headerView)
            m.bottom.equalTo(headerView.snp.top).inset(32)
        })
        
        calendar.snp.makeConstraints({ m in
            m.width.equalTo(headerView)
            m.top.equalTo(appNameLabel.snp.bottom)
            m.bottom.equalTo(headerView.snp.bottom)
        })
        
    }
    
    
    // MARK: Functions
    private func setUpDelegate() {
        calendar.delegate = self
        calendar.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func isAllViewHide(_ isHidden: Bool) {
        calendar.isHidden = isHidden
    }
    
    private func setUpSubscribers() {
        loadingSubscriber = viewModel.$loadingState.sink(receiveValue: {
            // API 호출 이후
            if $0 == .done {
                self.changeTodayLabel(date: self.viewModel.today)
                self.indicator.stopAnimating()
                self.isAllViewHide(false)
                self.tableView.reloadData()
            }
        })
        
//        daySubscriber = viewModel.$selectedDay.sink(receiveValue: {
//            self.setUpScrollSize(count: self.viewModel.schedules[$0!].count)
//        })
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = Int(dateFormatter.string(from: date))!
        viewModel.selectedDay = day
        tableView.reloadData()
        
        changeTodayLabel(date: date)
    }
    
    private func changeTodayLabel(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let month = Int(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "dd"
        let day = Int(dateFormatter.string(from: date))!
        todayLabel.text = "\(month)월 \(day)일"
    }
    
    private func setUpTableView() {
        tableView.register(MonthTableViewCell.self, forCellReuseIdentifier: "schedule_cell")
        tableView.rowHeight = 48
//        tableView.backgroundColor = .secondaryPurple
        tableView.backgroundColor = .brown
        tableView.bounces = false
        
        tableView.tableHeaderView = headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.schedules[viewModel.selectedDay].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedule_cell", for: indexPath)
        
        return cell
    }
}
