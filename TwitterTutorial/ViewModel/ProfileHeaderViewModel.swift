//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/26.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case twwets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .twwets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: "following")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 2, text: "following")
    }
    
    // ActionButton 연산
    var actionButtonTitle: String {
        // 선택한 유저가 본인일 때 : Edit Profile
        // 본인이 아닐때 : following / not folloing
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return "Follow"
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.foregroundColor : UIColor.lightGray, .font : UIFont.systemFont(ofSize: 14)]))
        return attributedTitle
    }
}
