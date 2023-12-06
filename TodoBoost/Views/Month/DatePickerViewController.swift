import UIKit
import SnapKit

final class DatePickerViewController: UIViewController {
    
    var delegate: DatePickerDelegate?
    var schedule: Schedule?
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.date = Date()
        return datePicker
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 설정"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.onTapConfirm(schedule: self.schedule!, date: datePicker.date)
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.red, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpGesture()
    }
    
    private func setUpView() {
        view.backgroundColor = .clear
        
        view.addSubview(contentView)
        contentView.addSubview(datePicker)
        contentView.addSubview(titleLabel)
        contentView.addSubview(confirmButton)
        contentView.addSubview(cancelButton)
        
        contentView.snp.makeConstraints({ m in
            m.left.right.bottom.equalToSuperview()
            m.height.equalTo(260)
        })
        
        titleLabel.snp.makeConstraints({ m in
            m.centerX.equalToSuperview()
            m.top.equalToSuperview().inset(12)
        })
        
        confirmButton.snp.makeConstraints({ m in
            m.centerY.equalTo(titleLabel)
            m.right.equalToSuperview().inset(20)
        })
        
        cancelButton.snp.makeConstraints({ m in
            m.centerY.equalTo(titleLabel)
            m.right.equalTo(confirmButton.snp.left).offset(-8)
        })
        
        datePicker.snp.makeConstraints({ m in
            m.left.right.equalToSuperview()
            m.center.equalToSuperview()
        })
    }
    
    private func setUpGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapView))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func onTapView() {
        self.dismiss(animated: true)
    }
}

protocol DatePickerDelegate {
    func onTapConfirm(schedule: Schedule, date: Date)
}
