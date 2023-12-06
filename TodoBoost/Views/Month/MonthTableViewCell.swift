import UIKit
import SnapKit

final class MonthTableViewCell: UITableViewCell {

    // MARK: - Constants
    private enum Constants {
        enum UI {
            static let leftMargin: ConstraintInsetTarget = 8
            static let rightMargin: ConstraintInsetTarget = 8
        }
    }
    
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Properties
    var viewModel: MonthViewModel?
    
    var isFocusing = false {
        didSet {
            if isFocusing {
                textField.isUserInteractionEnabled = true
                textField.becomeFirstResponder()
            } else {
                textField.isUserInteractionEnabled = false
                textField.resignFirstResponder()
            }
        }
    }
    
    var schedule: Schedule? {
        didSet {
            guard let schedule = schedule else { return }
            textField.text = schedule.title
            
            if schedule.isDone {
                checkButton.setImage(UIImage(systemName: "square.fill"), for: .normal)
            } else {
                checkButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
            
            if schedule.isImportant {
                textField.font = Configuration.shared.importantScheduleTheme.font
                textField.textColor = Configuration.shared.importantScheduleTheme.color
            } else {
                textField.font = UIFont.systemFont(ofSize: 18)
                textField.textColor = .white
            }
        }
    }
    
    var onTapDelete: (() -> Void)?
    var onTapNotificationSetting: (() -> Void)?
    
    // MARK: - UI
    private lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "수정", handler: { [weak self]_ in
                guard let self = self else { return }
                self.isFocusing = true
            }),
            UIAction(title: "알림 설정", handler: { [weak self]_ in
                guard let self = self else { return }
                self.onTapNotificationSetting?()
            }),
            UIAction(title: "삭제", attributes: [.destructive], handler: { [weak self] _ in
                guard let self = self, let viewModel = viewModel else { return }
                guard let schedule = self.schedule else { return }
                viewModel.deleteSchedule(id: schedule.id)
                self.onTapDelete?()
            })
        ]
    }()
    
    private var menu: UIMenu {
        return UIMenu(title: "", options: [], children: menuItems)
    }
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        return button
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .white
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private func configureUI() {
        checkButton.addTarget(self, action: #selector(onTapCheckButton), for: .touchUpInside)
        
        contentView.addSubview(textField)
        contentView.addSubview(checkButton)
        contentView.addSubview(optionButton)
        
        checkButton.snp.makeConstraints({ m in
            m.top.bottom.equalTo(contentView)
            m.left.equalTo(contentView).inset(Constants.UI.leftMargin)
            m.width.equalTo(40)
        })
        
        textField.snp.makeConstraints({ m in
            m.left.equalTo(checkButton.snp.right).offset(8)
            m.right.equalTo(optionButton.snp.left)
            m.top.bottom.centerY.equalToSuperview()
        })
        
        optionButton.snp.makeConstraints({ m in
            m.top.bottom.equalTo(contentView)
            m.right.equalTo(contentView).inset(Constants.UI.rightMargin)
            m.width.equalTo(40)
        })
    }
    
    @objc private func onTapCheckButton() {
        guard let done = schedule?.isDone else { return }
        
        if done {
            schedule?.isDone = false
            
        } else {
            schedule?.isDone = true
        }
        
        guard var newSchedule = schedule, let viewModel = viewModel else { return }
        viewModel.updateSchedule(id: newSchedule.id, schedule: newSchedule)
        
    }
}


// MARK: - TextField Delegate
extension MonthTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        schedule?.title = textField.text ?? ""
        guard var newSchedule = schedule, let viewModel = viewModel else { return true }
        viewModel.updateSchedule(id: newSchedule.id, schedule: newSchedule)
        
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        return true
    }
}
