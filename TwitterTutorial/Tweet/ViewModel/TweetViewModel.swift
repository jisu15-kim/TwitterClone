//
//  TweetViewModel.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/26.
//

import UIKit

// TweetCell 의 ViewModel
struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
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
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}