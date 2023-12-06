import UIKit
import SnapKit
import Combine
import FSCalendar

final class MonthViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Constants
    private enum Constants {
        enum UI {
            static let contentSideMargin: ConstraintInsetTarget = 16
        }
        enum ID {
            static let cellId = "schedule_cell"
        }
    }
    
    
    // MARK: - Properties
    private var viewModel: MonthViewModel
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TO DO BOOST"
        label.textColor = .white
        label.font = label.font.withSize(32)
        return label
    }()
    
    private let todayLabelView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(24)
        label.textColor = .white
        return label
    }()
    
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.text = viewModel.getMemo()
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .none
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    private lazy var memoEditButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            if self.memoTextView.isEditable {
                self.viewModel.setMemo(self.memoTextView.text)
            }
            self.memoTextView.isEditable = !self.memoTextView.isEditable
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Commons.shared.screenWidth, height: 240))
        
        let memoLabel = UILabel()
        memoLabel.font = UIFont.systemFont(ofSize: 24)
        memoLabel.textColor = .white
        memoLabel.text = "메모"

        view.addSubview(memoLabel)
        view.addSubview(memoTextView)
        view.addSubview(memoEditButton)
        
        memoLabel.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(24)
            m.top.equalToSuperview().inset(40)
        })
        
        memoTextView.snp.makeConstraints({ m in
            m.top.equalTo(memoLabel.snp.bottom).offset(12)
            m.centerX.equalToSuperview()
            m.width.equalTo(360)
            m.height.equalTo(132)
        })
        
        memoEditButton.snp.makeConstraints({ m in
            m.left.equalTo(memoLabel.snp.right).offset(8)
            m.centerY.equalTo(memoLabel)
            m.width.height.equalTo(24)
        })
        
        return view
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.style = .medium
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        return indicator
    }()
    
    private let calendar: FSCalendar = {
        let divider = UIView()
        divider.backgroundColor = .secondaryWhite
        
        let calendar = FSCalendar()
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
    
    
    // MARK: - Lifecycle
    init(viewModel: MonthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAllViewHide(true)
        indicator.startAnimating()
        viewModel.getScheduleInfo()
        memoTextView.isEditable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpDelegate()
        configureUI()
        setUpBindings()
    }
    
    private func setUpBindings() {
        viewModel.$loadingState.sink(receiveValue: {
            // API 호출 이후
            if $0 == .done {
                self.changeTodayLabel(stringDate: self.viewModel.today)
                self.indicator.stopAnimating()
                self.isAllViewHide(false)
                self.tableView.reloadData()
            }
        }).store(in: &cancellables)
        
        Configuration.shared.$themeColor.sink(receiveValue: { value in
            self.view.backgroundColor = value["primaryColor"]
            self.memoTextView.backgroundColor = value["primaryColor"]
            self.calendar.backgroundColor = value["primaryColor"]
            self.tableView.backgroundColor = value["secondaryColor"]
            self.headerView.backgroundColor = value["primaryColor"]
            self.todayLabelView.backgroundColor = value["secondaryColor"]
            
            self.tableView.reloadData()
        }).store(in: &cancellables)
    }
    
    // MARK: - UI
    private func configureUI() {
        isAllViewHide(true)
        
        view.addSubview(indicator)
        view.addSubview(tableView)
        headerView.addSubview(appNameLabel)
        headerView.addSubview(calendar)
        headerView.addSubview(todayLabelView)
        headerView.addSubview(todayLabel)
        
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
            m.left.right.equalTo(headerView).inset(Constants.UI.contentSideMargin)
            m.top.equalTo(appNameLabel.snp.bottom)
            m.bottom.equalTo(todayLabelView.snp.top)
        })
        
        todayLabelView.snp.makeConstraints({ m in
            m.left.right.bottom.equalTo(headerView)
            m.height.equalTo(60)
        })
        
        todayLabel.snp.makeConstraints({ m in
            m.centerY.equalTo(todayLabelView)
            m.left.equalTo(todayLabelView).inset(24)
        })
    }
    
    
    // MARK: - Functions & Selectors
    private func setUpDelegate() {
        calendar.delegate = self
        calendar.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func isAllViewHide(_ isHidden: Bool) {
        calendar.isHidden = isHidden
        tableView.isHidden = isHidden
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let stringDate = viewModel.getStringDateFromDate(of: date)
        viewModel.selectedDay = stringDate
        changeTodayLabel(stringDate: stringDate)
        tableView.reloadData()
    }
    
    private func changeTodayLabel(stringDate: StringDate) {
        todayLabel.text = "\(stringDate.month)월 \(stringDate.day)일"
    }
    
    private func setUpTableView() {
        tableView.register(MonthTableViewCell.self, forCellReuseIdentifier: Constants.ID.cellId)
        tableView.rowHeight = 48
        tableView.bounces = false
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionCount = Array(repeating: 0, count: viewModel.categories.count)
        for i in viewModel.schedules[viewModel.selectedDay.day] {
            sectionCount[i.categoryIndex] += 1
        }
        
        return sectionCount[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ID.cellId, for: indexPath) as? MonthTableViewCell else { return UITableViewCell() }
        for i in 0..<viewModel.schedules[viewModel.selectedDay.day].count {
            if viewModel.schedules[viewModel.selectedDay.day][i].categoryIndex == indexPath.section {
                cell.schedule = viewModel.schedules[viewModel.selectedDay.day][i + indexPath.row]
                break
            }
        }
        cell.viewModel = viewModel
        cell.onTapDelete = {
            self.tableView.reloadData()
        }
        cell.onTapNotificationSetting = {
            let vc = DatePickerViewController()
            vc.schedule = cell.schedule
            vc.delegate = self
            self.navigationController?.present(vc, animated: true)
        }
        cell.contentView.backgroundColor = Configuration.shared.themeColor["secondaryColor"]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Commons.shared.screenWidth, height: 0))
        header.backgroundColor = .clear
        
        let button = UIButton()
        button.setTitle(viewModel.categories[section] + " +", for: .normal)
        button.setTitleColor(.primaryMint, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.backgroundColor = .clear
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.appendEmptySchedule(to: self.viewModel.categories[section], stringDate: self.viewModel.selectedDay)
            let row = tableView.numberOfRows(inSection: section)
            self.tableView.reloadData()
            
            let newCell = (self.tableView.cellForRow(at: [section, row]) as! MonthTableViewCell)
            newCell.isFocusing = true
        }), for: .touchUpInside)

        header.addSubview(button)
        button.snp.makeConstraints({ m in
            m.centerY.equalTo(header)
            m.left.equalTo(header).inset(Constants.UI.contentSideMargin)
        })
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


// MARK: - DatePickerDelegate
extension MonthViewController: DatePickerDelegate {
    func onTapConfirm(schedule: Schedule, date: Date) {
        
        if date.timeIntervalSince1970 - Date().timeIntervalSince1970 <= 0 { return }
        
        // 알림설정 노티 보내기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr = dateFormatter.string(from: date)
        Commons.shared.requestSendNoti(title: "알림 설정", body: "\(dateStr) 알림이 설정되었습니다.", seconds: 1)
        
        // 로컬 노티 설정
        let interval = date.timeIntervalSince1970 - Date().timeIntervalSince1970
        
        // 테스트용
        Commons.shared.requestSendNoti(title: "알림", body: "\(schedule.title)", seconds: Int(5))
        
    }
}
