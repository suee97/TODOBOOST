import UIKit
import SnapKit
import Combine

final class ImportantColorViewController: UIViewController {

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpGesture()
        setUpBindings()
    }
    
    private func setUpBindings() {
        Configuration.shared.$importantScheduleTheme.sink(receiveValue: { value in
            self.colorView.backgroundColor = value.color
        }).store(in: &cancellables)
    }
    
    
    // MARK: - UI
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "Color"
        return label
    }()
    
    private lazy var colorTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .lightGray
        tf.layer.cornerRadius = 12
        tf.textAlignment = .center
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tf.text = Configuration.shared.importantScheduleTheme.color.toHexString()
        return tf
    }()

    private func setUpView() {
        view.backgroundColor = .clear
        
        view.addSubview(contentView)
        contentView.addSubview(colorView)
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorTextField)
        
        contentView.snp.makeConstraints({ m in
            m.left.right.bottom.equalToSuperview()
            m.height.equalTo(270)
        })
        
        colorView.snp.makeConstraints({ m in
            m.width.height.equalTo(140)
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().inset(52)
        })
        
        colorLabel.snp.makeConstraints({ m in
            m.centerX.equalTo(colorView)
            m.bottom.equalTo(colorView.snp.top).offset(-16)
        })
        
        colorTextField.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalTo(colorView.snp.bottom).offset(12)
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
        guard let text = sender.text else { return }
        if text.count == 7 {
            Configuration.shared.importantScheduleTheme.color = UIColor(hexCode: text)
        }
    }
}
