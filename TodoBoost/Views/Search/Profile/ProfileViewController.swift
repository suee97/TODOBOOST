import UIKit
import SnapKit
import Kingfisher
import Combine

final class ProfileViewController: UIViewController {

    // MARK: - Constants
    private enum Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let cell_id = "Follower_Schedule_Cell"
        static var appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            return appearance
        }()
        
        enum Header {
            static let height: CGFloat = 306
        }
        
        enum ProfileImage {
            static let diameter: CGFloat = 120
            static let topMargin: CGFloat = 78
        }
        
        enum NickName {
            static let font = UIFont.boldSystemFont(ofSize: 24)
            static let topMargin: CGFloat = 28
        }
    }
    
    
    // MARK: - Properties
    private var follower: Follower
    private var cancellables = Set<AnyCancellable>()
    private var sectionList = ["Community", "Life", "Exercise"]
    private var scheduleList = [
        ["오전 11시 축구", "저녁에 친구랑 밥먹기"],
        ["화분에 물 주기", "오후 10시 이전에 눕기"],
        ["운동 2시간 하기"]
    ]
    
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        Constants.appearance.backgroundColor = .clear
        navigationController?.navigationBar.compactAppearance = Constants.appearance
        navigationController?.navigationBar.standardAppearance = Constants.appearance
        navigationController?.navigationBar.scrollEdgeAppearance = Constants.appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
        setUpBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    init(follower: Follower) {
        self.follower = follower
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBindings() {
        Configuration.shared.$themeColor.sink(receiveValue: { value in
            self.tableView.backgroundColor = value["primaryColor"]
            self.headerView.backgroundColor = value["primaryColor"]
        }).store(in: &cancellables)
    }
    
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = headerView
        tableView.bounces = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.rowHeight = 48
        return tableView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Commons.shared.screenWidth, height: Constants.Header.height))
        
        view.addSubview(profileImageView)
        view.addSubview(nicknameLabel)
        
        profileImageView.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.width.height.equalTo(Constants.ProfileImage.diameter)
            m.top.equalToSuperview().inset(Constants.ProfileImage.topMargin)
        })
        
        nicknameLabel.snp.makeConstraints({ m in
            m.top.equalTo(profileImageView.snp.bottom).offset(Constants.NickName.topMargin)
            m.centerX.equalToSuperview()
        })
        
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = Constants.ProfileImage.diameter / 2
        imageView.clipsToBounds = true
        
        let url = URL(string: follower.userImageUrl)
        imageView.kf.setImage(with: url)
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = follower.nickname
        label.font = Constants.NickName.font
        label.textColor = .white
        return label
    }()
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FollowerScheduleCell.self, forCellReuseIdentifier: Constants.cell_id)
    }
    
    private func setUpView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({ m in
            m.edges.equalTo(view)
            m.top.equalTo(view)
        })

    }
}

// MARK: - TableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell_id, for: indexPath) as? FollowerScheduleCell else { return UITableViewCell() }
        cell.update(scheduleString: scheduleList[indexPath.section][indexPath.row])
        print(scheduleList[indexPath.section][indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Commons.shared.screenWidth, height: 0))
        header.backgroundColor = .clear
        
        let button = UIButton()
        button.setTitle(sectionList[section], for: .normal)
        button.setTitleColor(.primaryMint, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.backgroundColor = .clear

        header.addSubview(button)
        button.snp.makeConstraints({ m in
            m.centerY.equalTo(header)
            m.left.equalTo(header).inset(16)
        })
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
