import UIKit
import SnapKit
import Combine

class ThemeColorViewController: UIViewController {

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBindings()
        setUpGesture()
    }
    
    private func setUpBindings() {
        Configuration.shared.$themeColor.sink(receiveValue: { value in
            self.primaryColorView.backgroundColor = value["primaryColor"]
            self.secondaryColorView.backgroundColor = value["secondaryColor"]
        
        }).store(in: &cancellables)
    }
    
    
    // MARK: - UI
    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "Primary"
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "Secondary"
        return label
    }()
    
    private let primaryColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let secondaryColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var primaryTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .lightGray
        tf.layer.cornerRadius = 12
        tf.textAlignment = .center
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.text = Configuration.shared.themeColor["primaryColor"]?.toHexString()
        return tf
    }()
    
    private lazy var secondaryTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .lightGray
        tf.layer.cornerRadius = 12
        tf.textAlignment = .center
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.text = Configuration.shared.themeColor["secondaryColor"]?.toHexString()
        return tf
    }()

    private func setUpView() {
        view.backgroundColor = .clear
        
        view.addSubview(contentView)
        contentView.addSubview(primaryColorView)
        contentView.addSubview(secondaryColorView)
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(primaryTextField)
        contentView.addSubview(secondaryTextField)
        
        contentView.snp.makeConstraints({ m in
            m.left.right.bottom.equalToSuperview()
            m.height.equalTo(270)
        })
        
        primaryColorView.snp.makeConstraints({ m in
            m.width.height.equalTo(140)
            m.left.equalToSuperview().inset(36)
            m.top.equalToSuperview().inset(52)
        })
        
        secondaryColorView.snp.makeConstraints({ m in
            m.width.height.equalTo(140)
            m.right.equalToSuperview().inset(36)
            m.top.equalToSuperview().inset(52)
        })
        
        primaryLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(primaryColorView)
            m.bottom.equalTo(primaryColorView.snp.top).offset(-16)
        })
        
        secondaryLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(secondaryColorView)
            m.bottom.equalTo(secondaryColorView.snp.top).offset(-16)
        })
        
        primaryTextField.snp.makeConstraints({ m in
            m.centerX.equalTo(primaryColorView)
            m.top.equalTo(primaryColorView.snp.bottom).offset(12)
            m.height.equalTo(28)
            m.width.equalTo(120)
        })
        
        secondaryTextField.snp.makeConstraints({ m in
            m.centerX.equalTo(secondaryColorView)
            m.top.equalTo(secondaryColorView.snp.bottom).offset(12)
            m.height.equalTo(28)
            m.width.equalTo(120)
        })
    }
    
    private func setUpGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapView))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func onTapView() {
        self.dismiss(animated: true)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        if sender == primaryTextField && sender.text?.count == 7 {
            Configuration.shared.themeColor["primaryColor"] = UIColor(hexCode: sender.text!)
        } else if sender == secondaryTextField && sender.text?.count == 7 {
            Configuration.shared.themeColor["secondaryColor"] = UIColor(hexCode: sender.text!)
        }
    }
}
