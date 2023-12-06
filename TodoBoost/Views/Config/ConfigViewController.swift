import UIKit
import SnapKit
import Combine

final class ConfigViewController: UIViewController, UIFontPickerViewControllerDelegate {
    
    // MARK: - Constants
    private enum Constants {
        enum Header {
            static let height: CGFloat = 320
        }
        
        enum ProfileImage {
            static let diameter: CGFloat = 104
            static let topMargin: CGFloat = 60
        }
        
        enum Nickname {
            static let fontSize: CGFloat = 24
            static let topMargin: CGFloat = 32
        }
        
        enum Section {
            static let sectionHeight: CGFloat = 28
            static let cellHeight: CGFloat = 40
            static let titleLeftMargin: CGFloat = 28
            static let fontColor = UIColor(red: 243/255, green: 243/255, blue: 248/255, alpha: 1)
            static let fontSize: CGFloat = 12
        }
    }
    
    
    // MARK: - Properties
    private let viewModel: ConfigViewModel = .init()
    private var monthViewModel: MonthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpView()
        setUpBindings()
    }
    
    private func setUpBindings() {
        Configuration.shared.$themeColor.sink(receiveValue: { value in
            self.view.backgroundColor = value["pirmaryColor"]
            self.tableView.backgroundColor = value["primaryColor"]
            self.tableView.reloadData()
        }).store(in: &cancellables)
    }
    
    init(viewModel: MonthViewModel) {
        self.monthViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Commons.shared.screenWidth, height: Constants.Header.height)))
        return view
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "messi1"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.ProfileImage.diameter / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "suee__"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Constants.Nickname.fontSize)
        return label
    }()

    private func setUpView() {
        view.addSubview(tableView)
        headerView.addSubview(profileImage)
        headerView.addSubview(nicknameLabel)
        
        tableView.snp.makeConstraints({ m in
            m.left.right.top.bottom.equalTo(view)
        })
        
        profileImage.snp.makeConstraints({ m in
            m.width.height.equalTo(Constants.ProfileImage.diameter)
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().inset(Constants.ProfileImage.topMargin)
        })
        
        nicknameLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(profileImage.snp.bottom).offset(Constants.Nickname.topMargin)
        })
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConfigCell.self, forCellReuseIdentifier: ConfigCell.id)
        tableView.tableHeaderView = headerView
    }
}


// MARK: - TableView
extension ConfigViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].seciontList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConfigCell.id, for: indexPath) as? ConfigCell else {
            return UITableViewCell()
        }
        cell.configRoute = viewModel.sections[indexPath.section].seciontList[indexPath.row]
        cell.backgroundColor = Configuration.shared.themeColor["primaryColor"]
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.text = viewModel.sections[section].title
        label.textColor = Constants.Section.fontColor
        label.font = UIFont.systemFont(ofSize: Constants.Section.fontSize)
        view.addSubview(label)
        label.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(Constants.Section.titleLeftMargin)
            m.centerY.equalToSuperview()
        })
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.Section.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Section.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(viewModel.sections[indexPath.section].seciontList[indexPath.row].rawValue)
        
        let selection = viewModel.sections[indexPath.section].seciontList[indexPath.row]
        switch selection {
        case .themeColor:
            let vc = ThemeColorViewController()
            navigationController?.present(vc, animated: true)
        case .importantFont:
            let config = UIFontPickerViewController.Configuration()
            config.includeFaces = true
            let vc = UIFontPickerViewController(configuration: config)
            vc.delegate = self
            navigationController?.present(vc, animated: true)
        case .importantColor:
            let vc = ImportantColorViewController()
            navigationController?.present(vc, animated: true)
        case .appendCategory:
            let vc = CategorySettingViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .initialize:
            let alert = UIAlertController(title: "주의", message: "확인을 누르시면 모든 데이터가 초기화됩니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("취소", comment: "Default action"), style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: { _ in
                NetworkService.shared.categories = []
                NetworkService.shared.schedules = []
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        let font = UIFont(descriptor: descriptor, size: 18)
        Configuration.shared.importantScheduleTheme.font = font
        self.dismiss(animated: true)
    }
}
