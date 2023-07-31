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
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    private let todoView: UIView = {
        let view = UIView()
//        view.backgroundColor = .secondaryPurple
        view.backgroundColor = .gray
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
        label.backgroundColor = .systemMint
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
    
    private let memoView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
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
        view.backgroundColor = .systemBlue
//
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        contentView.addSubview(appNameLabel)
//        contentView.addSubview(calendar)
//        contentView.addSubview(todayLabel)
//        contentView.addSubview(tableView)
//        scrollView.addSubview(appNameLabel)
//        contentView.addSubview(calendar)
//        contentView.addSubview(todoView)
//        scrollView.addSubview(indicator)
//        todoView.addSubview(tableView)
//        todoView.addSubview(todayLabel)
        
        
        
//        scrollView.snp.makeConstraints({ m in
//            m.left.right.top.bottom.equalTo(view)
//        })
//
//        contentView.snp.makeConstraints({ m in
//            m.left.right.top.bottom.equalTo(scrollView)
//            m.width.height.equalTo(scrollView)
//        })
//
//        appNameLabel.snp.makeConstraints({ m in
//            m.centerX.equalTo(contentView)
//            m.top.equalTo(contentView.safeAreaLayoutGuide)
//        })
//
//        calendar.snp.makeConstraints({ m in
//            m.left.right.equalTo(contentView).inset(contentSideMargin)
//            m.top.equalTo(appNameLabel.snp.bottom).offset(16)
//            m.height.equalTo(300)
//        })
//
//        todayLabel.snp.makeConstraints({ m in
//            m.left.equalTo(contentView).inset(48)
//            m.top.equalTo(calendar.snp.bottom).offset(20)
//        })
//
//        tableView.snp.makeConstraints({ m in
////            m.left.right.equalTo(todoView)
//            //            m.bottom.equalTo(todoView).inset(200)
//            //            m.top.equalTo(todoView).inset(72)
//            m.left.right.equalTo(contentView)
//            m.top.equalTo(todayLabel.snp.bottom)
//
//        })
        
        
//        todoView.snp.makeConstraints({ m in
//            m.left.right.equalTo(view)
//            m.top.equalTo(calendar.snp.bottom)
//            m.bottom.equalTo(scrollView.contentLayoutGuide)
//            m.left.right.equalTo(scrollView.contentLayoutGuide)
//        })
        
//        todayLabel.snp.makeConstraints({ m in
//            m.left.equalTo(todoView).inset(48)
//            m.top.equalTo(todoView).inset(20)
//        })
        
//
//        indicator.snp.makeConstraints({ m in
//            m.centerX.centerY.equalTo(view)
//        })
        
//        tableView.snp.makeConstraints({ m in
//            m.left.right.equalTo(todoView)
//            m.bottom.equalTo(todoView).inset(200)
//            m.top.equalTo(todoView).inset(72)
//        })
        
//        todayLabel.snp.makeConstraints({ m in
//            m.left.equalTo(todoView).inset(48)
//            m.top.equalTo(todoView).inset(20)
//        })
        
//        memoView.snp.makeConstraints({ m in
//            m.width.height.equalTo(200)
//            m.bottom.equalTo(scrollView)
//        })
        
        
//        todoView.snp.makeConstraints({ m in
//            m.width.equalTo(200)
//            m.height.equalTo(200)
//            m.centerX.equalTo(contentView)
//            m.top.equalTo(contentView).inset(400)
//            m.bottom.equalTo(contentView)
//        })
        
        isAllViewHide(true)
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
        todoView.isHidden = isHidden
    }
    
    private func setUpSubscribers() {
        loadingSubscriber = viewModel.$loadingState.sink(receiveValue: {
            // API 호출 이후
            if $0 == .done {
                self.setUpScrollSize(count: self.viewModel.schedules[self.viewModel.selectedDay].count)
                self.changeTodayLabel(date: self.viewModel.today)
                self.indicator.stopAnimating()
                self.isAllViewHide(false)
                self.tableView.reloadData()
            }
        })
        
        daySubscriber = viewModel.$selectedDay.sink(receiveValue: {
            self.setUpScrollSize(count: self.viewModel.schedules[$0!].count)
        })
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
        tableView.isScrollEnabled = false
        tableView.rowHeight = 48
//        tableView.backgroundColor = .secondaryPurple
        tableView.backgroundColor = .magenta.withAlphaComponent(0.5)
    }
    
    private func setUpScrollSize(count: Int) {
//        let height = todoView.frame.minY + 72 + CGFloat(count * 48) + 500
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: height)
//
//        print("MonthViewController setUpScrollSize() - height : \(height)")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.schedules[viewModel.selectedDay].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedule_cell", for: indexPath)
        
        return cell
    }
}




/*
 하윙
 나는야 오빠의 여자친구 슬비
 요즘 너무 속 썩여서 슬프지 ㅠㅠ
 미안해
 오빠 닮아서 가슴에 대못 박는 소리를 많이 하네 ... ^^
 난 오빠가 너무 편해
 편해서 좋고 그래서 그게 당연해
 우리 둘이 서로 좋아하면 하는 행동이 점점 달라지는데
 그래도 서로를 끝까지 놓지말자
 내가 바쁜 건 너무 미안해
 근데 내가 어떻게 할 수 있는 부분이 아니라서 ...
 대신 나중에 오빠가 바쁠 때 찍소리도 안할게 !!!
 서로의 삶을 존중해주면서 만날 수 있는 예쁜 커플이 되었으면 좋겠어
 사랑해 안녕
 */
