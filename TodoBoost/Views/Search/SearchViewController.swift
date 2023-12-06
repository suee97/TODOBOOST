import UIKit
import SnapKit
import Combine

final class SearchViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - UI
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .secondaryWhite
        indicator.startAnimating()
        return indicator
    }()
    
    private let searchUnSafeAreaView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let searchTopView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디 또는 닉네임을 입력하세요."
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondaryWhite
        textField.clearButtonMode = .always
        textField.textColor = .black
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "magnifyingglass")
        button.setImage(image, for: .normal)
        button.tintColor = .secondaryWhite
        button.addTarget(self, action: #selector(onTapSearchButton), for: .touchUpInside)
        return button
    }()
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: Commons.shared.screenWidth, height: 80)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func setUpView() {
        view.addSubview(collectionView)
        view.addSubview(indicator)
        view.addSubview(searchUnSafeAreaView)
        view.addSubview(searchTopView)
        searchTopView.addSubview(searchField)
        searchTopView.addSubview(searchButton)
        
        searchUnSafeAreaView.snp.makeConstraints({ m in
            m.left.right.top.equalTo(view)
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
        
        searchTopView.snp.makeConstraints({ m in
            m.left.right.equalTo(view)
            m.top.equalTo(view.safeAreaLayoutGuide)
            m.height.equalTo(60)
        })
        
        searchField.snp.makeConstraints({ m in
            m.centerY.equalTo(searchTopView)
            m.left.equalTo(searchTopView).inset(12)
            m.width.equalTo(320)
            m.height.equalTo(40)
        })
        
        searchButton.snp.makeConstraints({ m in
            m.centerY.equalTo(searchTopView)
            m.left.equalTo(searchField.snp.right).offset(8)
            m.width.height.equalTo(40)
        })
        
        collectionView.snp.makeConstraints({ m in
            m.left.right.bottom.equalTo(view)
            m.top.equalTo(searchTopView.snp.bottom)
        })
        
        indicator.snp.makeConstraints({ m in
            m.center.equalTo(view)
        })
    
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpBindings()
        setUpView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Functions
    private func setUpBindings() {
        viewModel.$loadingState.sink(receiveValue: { value in
            switch value {
            case .done:
                self.indicator.isHidden = true
            case .error:
                self.indicator.isHidden = false
            case .loading:
                self.indicator.isHidden = false
            }
        }).store(in: &cancellables)
        
        viewModel.$followers.sink(receiveValue: { value in
            self.collectionView.reloadData()
            print(value)
        }).store(in: &cancellables)
        
        Configuration.shared.$themeColor.sink(receiveValue: { value in
            self.view.backgroundColor = value["primaryColor"]
            self.searchTopView.backgroundColor = value["secondaryColor"]
            self.searchUnSafeAreaView.backgroundColor = value["secondaryColor"]
        }).store(in: &cancellables)
    }
    
    @objc private func onTapSearchButton() {
        print("search button tapped!")
        view.endEditing(true)
        let text = searchField.text ?? ""
        viewModel.getFollowers(nickname: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        viewModel.getFollowers(nickname: text)
        view.endEditing(true)
        return true
    }
}

// MARK: - CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.followers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.id, for: indexPath) as? FollowerCell else { return UICollectionViewCell() }
        cell.follower = viewModel.followers[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfileViewController(follower: viewModel.followers[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
