//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/27.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    //MARK: - Properties
    var viewModel: TweetViewModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        // 탭 제스쳐
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Dummy"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "@dummy"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        button.tintColor = .gray
        return button
    }()
    
    private lazy var retweetLabel = UILabel()
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
            $0.height.equalTo(1)
        }
        
        let stack = UIStackView(arrangedSubviews: [retweetLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
            $0.height.equalTo(1)
        }
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButtons(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButtons(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButtons(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButtons(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc func handleProfileImageTapped() {
        print(#function)
    }
    
    @objc func showActionSheet() {
        print(#function)
    }
    
    @objc func handleCommentTapped() {
        print(#function)
    }
    
    @objc func handleRetweetTapped() {
        print(#function)
    }
    
    @objc func handleLikeTapped() {
        print(#function)
    }
    
    @objc func handleShareTapped() {
        print(#function)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 12
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(stack.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).inset(-20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        addSubview(optionsButton)
        optionsButton.snp.makeConstraints {
            $0.centerY.equalTo(stack)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        addSubview(statsView)
        statsView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(dateLabel.snp.bottom).inset(-12)
            $0.height.equalTo(40)
        }
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(statsView.snp.bottom).inset(-16)
        }
    }
    
    //MARK: - Helper
    private func createButtons(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    private func configure() {
        guard let vm = viewModel else { return }
        captionLabel.text = vm.tweet.caption
        fullnameLabel.text = vm.tweet.user.fullname
        usernameLabel.text = vm.usernameText
        profileImageView.kf.setImage(with: vm.tweet.user.profileImageUrl)
        dateLabel.text = vm.headerTimeStamp
        retweetLabel.attributedText = vm.retweetsAttributedString
        likesLabel.attributedText = vm.likesAttributedString
    }
}
