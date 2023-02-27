//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/26.
//

import UIKit

private let backImageName = "baseline_arrow_back_white_24dp"

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismiss()
    func handleEditProfileFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    private let filterBar = ProfileFilterView()
    
    //MARK: - Properties
    weak var delegate: ProfileHeaderDelegate?
    
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(30)
        }
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: backImageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "테스트 테스트 테스ㅡㅌ BIO Label 테스트 테스트 테스ㅡㅌ BIO Label 테스트 테스트 테스ㅡㅌ BIO Label"
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowingTapped() {
        print(#function)
    }
    
    @objc func handleFollowersTapped() {
        print(#function)
    }
    
    //MARK: - Helper
    func setupUI() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).inset(24)
            $0.leading.equalToSuperview().inset(8)
            $0.width.height.equalTo(80)
            profileImageView.layer.cornerRadius = 80 / 2
        }
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).inset(-12)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(100)
            $0.height.equalTo(36)
            editProfileFollowButton.layer.cornerRadius = 36 / 2
        }
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel,
                                                             usernameLabel,
                                                             bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        userDetailStack.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).inset(-8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fill
        
        addSubview(followStack)
        followStack.snp.makeConstraints {
            $0.top.equalTo(userDetailStack.snp.bottom).inset(-8)
            $0.leading.equalToSuperview().inset(12)
        }
        
        addSubview(filterBar)
        filterBar.delegate = self
        filterBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        addSubview(underlineView)
        underlineView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo(frame.width / CGFloat(ProfileFilterOptions.allCases.count))
            $0.height.equalTo(2)
        }
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        profileImageView.kf.setImage(with: viewModel.user.profileImageUrl)
        
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        fullnameLabel.text = viewModel.user.fullname
        usernameLabel.text = viewModel.usernameText
        
        editProfileFollowButton.setTitleColor(viewModel.user.followStatus.titleColor, for: .normal)
        editProfileFollowButton.setTitle(viewModel.user.followStatus.title, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.user.followStatus.backgroundColor
    }
}

//MARK: - ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexpath: IndexPath) {
        
        // 1. Delegate로 FilterBar내부 콜렉션뷰의 Cell의 액션을 받는다
        // 2. 받은 매개변수로 FilterBar 내부 콜렉션뷰 셀을 찾아간다
        // 3. 그 셀의 xPosition을 찾는다
        // 4. underlineView의 xPosition을 그곳으로 보낸다
        // 근데 왜 ProfileBar 내부에 구현하면 안될까?
        guard let cell = view.collectionView.cellForItem(at: indexpath) as? ProfileFilterCell else { return }
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
