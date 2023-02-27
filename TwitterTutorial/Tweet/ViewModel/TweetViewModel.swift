//
//  TweetViewModel.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/26.
//

import UIKit
import Combine

// TweetCell 의 ViewModel
class TweetViewModel {
    //MARK: - Properties
    let tweet: Tweet
    let user: User
    var replies: CurrentValueSubject<[Tweet], Never>
    
    var profileUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? ""
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetsAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var userInfoText: NSAttributedString {
        // FullName
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        // UserName
        title.append(NSAttributedString(string: " @\(user.username)",
                                        attributes: [.font : UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor : UIColor.lightGray]))
        // TimeStamp
        title.append(NSAttributedString(string: " ・ \(timestamp)",
                                        attributes: [.font : UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor : UIColor.lightGray]))
        // 3개의 문자열을 합쳐서 return
        return title
    }
    //MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
        self.replies = CurrentValueSubject([])
    }
    
    //MARK: - API
    func fetchReplies() {
        print(#function)
        TweetService.shared.fetchReplies(forTweet: tweet) { [weak self] replies in
            self?.replies.send(replies)
        }
    }
    
    //MARK: - Helper
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.foregroundColor : UIColor.lightGray, .font : UIFont.systemFont(ofSize: 14)]))
        return attributedTitle
    }
    
    func size(forwith width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        let size = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }
    
    func getRepliesCount() -> Int {
        return replies.value.count
    }
    
    func getRepliesCellViewModel(index: IndexPath) -> TweetViewModel {
        let reply = replies.value[index.row]
        let vm = TweetViewModel(tweet: reply)
        return vm
    }
}
