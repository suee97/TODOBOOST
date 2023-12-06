import UIKit
import SnapKit

final class ConfigCell: UITableViewCell {
    
    // MARK: - Constants
    static let id = "config_cell"
    private enum Constants {
        static let titleLeftMargin: CGFloat = 28
        static let fontSize: CGFloat = 16
        static let fontColor = UIColor(red: 252/255, green: 252/255, blue: 255/255, alpha: 1)
        static let buttonColor = UIColor(red: 243/255, green: 243/255, blue: 248/255, alpha: 0.7)
        static let buttonRightMargin: CGFloat = 36
    }
    
    // MARK: - Properties
    var configRoute: ConfigRoute? {
        didSet {
            titleLabel.text = configRoute?.rawValue ?? ""
        }
    }
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.fontColor
        label.font = UIFont.systemFont(ofSize: Constants.fontSize)
        return label
    }()
    
    private let navigateButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = Constants.buttonColor
        return button
    }()
    
    private func setUpView() {        
        contentView.addSubview(titleLabel)
        contentView.addSubview(navigateButton)
        
        titleLabel.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().inset(Constants.titleLeftMargin)
        })
        
        navigateButton.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.right.equalToSuperview().inset(Constants.buttonRightMargin)
        })
    }
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
