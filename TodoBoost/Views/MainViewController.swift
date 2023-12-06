import UIKit
import SnapKit

class MainViewController: UIViewController, UITabBarControllerDelegate {
    
    private let myTabBarController = UITabBarController()
    
    private let viewModel = MonthViewModel()
    
    private lazy var monthViewController = MonthViewController(viewModel: viewModel)
    private let dayViewController = SearchViewController()
    private lazy var configViewController = ConfigViewController(viewModel: viewModel)
    private var viewList: [UIViewController] = []
    
    private let monthItem: UITabBarItem = {
        let item = UITabBarItem()
        item.title = "Month"
        item.image = UIImage(systemName: "calendar")
        return item
    }()
    
    private let dayItem: UITabBarItem = {
        let item = UITabBarItem()
        item.title = "Search"
        item.image = UIImage(systemName: "magnifyingglass")
        return item
    }()
    
    private let configItem: UITabBarItem = {
        let item = UITabBarItem()
        item.title = "Configuration"
        item.image = UIImage(systemName: "list.triangle")
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTabBar()
        Commons.shared.requestAuthNoti()
    }
    
    private func configureUI() {
        view.backgroundColor = .tabBarColor
        
        view.addSubview(myTabBarController.view)
        
        myTabBarController.view.snp.makeConstraints({ m in
            m.left.right.top.equalTo(view)
            m.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
    }
    
    private func setUpTabBar() {
        viewList = [monthViewController, dayViewController, configViewController]
        monthViewController.tabBarItem = monthItem
        dayViewController.tabBarItem = dayItem
        configViewController.tabBarItem = configItem
        
        let navConList = viewList.map({
            UINavigationController(rootViewController: $0)
        })
        
        for e in navConList {
            e.isNavigationBarHidden = true
        }
        
        myTabBarController.setViewControllers(navConList, animated: true)
        myTabBarController.tabBar.backgroundColor = .tabBarColor
    }

}

