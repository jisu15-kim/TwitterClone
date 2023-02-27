//
//  ProfileController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/26.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    //MARK: - Properties
    private var user: User {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var tweets: [Tweet] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        // 이거 왜 안되지: ??
        self.navigationController?.navigationBar.barStyle = .black
    }
    //MARK: - selector
    
    //MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { [weak self] tweets in
            self?.tweets = tweets
        }
    }
    
    func checkIfUserIsFollowed() {
        if !self.user.isCurrentUser {
            UserService.shared.checkIfUserIsFollowed(uid: user.uid) { [weak self] isFollowed in
                if isFollowed {
                    self?.user.followStatus = .following
                } else {
                    self?.user.followStatus = .unfollowing
                }
            }
        } else {
            self.user.followStatus = .currentUser
        }
    }
    
    //MARK: - Helper
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        // 🔥⬇️ CollectionView가 Statusbar로도 올라가기
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

//MARK: - Collectionview Delegate / Datasource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}
//MARK: - CollectionView Header
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
}

//MARK: - DelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    // 헤더 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    // 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func handleEditProfileFollow(_ header: ProfileHeader) {
        if user.isCurrentUser {
            print("Edit Profile Tapped")
            return
        }
        
        switch user.followStatus {
        case .following:
            UserService.shared.unfollowUser(uid: user.uid) { [weak self] (error, ref) in
                self?.user.followStatus = .unfollowing
            }
        case .unfollowing:
            UserService.shared.followUser(uid: user.uid) { [weak self] (error, ref) in
                self?.user.followStatus = .following
            }
        default:
            return
        }
    }
    
    func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
}
