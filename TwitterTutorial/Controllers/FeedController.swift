//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "TweetCell"

protocol FeedControllerDelegate: AnyObject {
    func logoutTapped()
}

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    weak var delegate: FeedControllerDelegate?
    
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var tweets: [Tweet] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
    }
    //MARK: - Selector
    @objc func handleMyImageTapped() {
        AuthService.shared.logUserOut { [weak self] in
            self?.delegate?.logoutTapped()
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView

        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.clipsToBounds = true
        profileImageView.kf.setImage(with: user.profileImageUrl)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleMyImageTapped))
        profileImageView.addGestureRecognizer(gesture)
        profileImageView.isUserInteractionEnabled = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

//MARK: - UICollectionViewDelegate/Datasource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.viewModel = TweetViewModel(tweet: tweet)
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TweetController(viewModel: TweetViewModel(tweet: tweets[indexPath.row]))
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

//MARK: - TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.viewModel?.tweet.user else { return }
        let vc = ProfileController(viewModel: ProfileViewModel(user: user))
        navigationController?.pushViewController(vc, animated: true)
    }
}
