import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()
    private let height = UIScreen.main.bounds.height
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryPurple
        view.layer.cornerRadius = height / 2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TO DO BOOST"
        label.font = label.font.withSize(40)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        viewModel.autoLogin()
    }
    
    private func bind() {
        viewModel.loadingState?.subscribe(listener: { state in
            if (state == .done) {
                self.indicator.stopAnimating()
                self.goToMain()
            }
        })
    }
    
    private func goToMain() {
        let vc = MainViewController()
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    private func configureUI() {
        view.backgroundColor = .primaryPurple
        
        view.addSubview(topView)
        view.addSubview(titleLabel)
        view.addSubview(indicator)
        
        topView.snp.makeConstraints({ m in
            m.width.equalTo(height)
            m.height.equalTo(height)
            m.centerX.equalTo(view)
            m.bottom.equalTo(view.snp.top).inset(height * 0.4)
        })
        
        titleLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(view)
            m.top.equalTo(view.safeAreaLayoutGuide).inset(height * 0.1)
        })
        
        indicator.snp.makeConstraints({ m in
            m.centerX.centerY.equalTo(view)
        })
    }
}
