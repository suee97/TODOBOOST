import UIKit

final class FollowerCell: UICollectionViewCell {
    static let id = "follower_cell"
    
    var follower: Follower? {
        didSet {
            guard let urlString: String = follower?.userImageUrl else { return }
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    }
                }
            }
            
            descLabel.text = follower?.description ?? ""
            nameLabel.text = follower?.nickname ?? ""
            
            let notification = follower?.notification ?? false
            notiButton.setImage(UIImage(systemName: notification ? "bell.fill" : "bell.slash.fill"), for: .normal)
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 27
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryWhite
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryWhite
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let notiButton: UIButton = {
        let button = UIButton()
        button.tintColor = .secondaryWhite
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        contentView.addSubview(imageView)
        contentView.addSubview(descLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(notiButton)
        
        imageView.snp.makeConstraints({ m in
            m.centerY.equalTo(contentView)
            m.left.equalTo(contentView).inset(24)
            m.width.height.equalTo(54)
        })
        
        descLabel.snp.makeConstraints({ m in
            m.left.equalTo(imageView.snp.right).offset(12)
            m.top.equalTo(contentView).inset(16)
        })
        
        nameLabel.snp.makeConstraints({ m in
            m.left.equalTo(imageView.snp.right).offset(12)
            m.top.equalTo(descLabel.snp.bottom).offset(6)
        })
        
        notiButton.snp.makeConstraints({ m in
            m.centerY.equalTo(contentView)
            m.right.equalTo(contentView).offset(-12)
        })
    }
}
