import UIKit
import SnapKit
import Combine

final class FollowerScheduleCell: UITableViewCell {
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        setUpBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBindings() {
        Configuration.shared.$themeColor.sink(receiveValue: { value in
            self.contentView.backgroundColor = value["primaryColor"]
        }).store(in: &cancellables)
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private func setUpView() {
        contentView.addSubview(label)
        label.snp.makeConstraints({ m in
            m.left.equalToSuperview().inset(16)
            m.centerY.equalToSuperview()
        })
    }
    
    func update(scheduleString: String) {
        label.text = scheduleString
    }
}
