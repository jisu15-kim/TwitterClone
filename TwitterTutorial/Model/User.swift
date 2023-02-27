//
//  User.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import Firebase

struct User {
    
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    var followStatus: FollowStatus = .loading
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String : AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrl) else { return }
            self.profileImageUrl = url
        }
    }
}

enum FollowStatus: CaseIterable {
    case loading
    case following
    case unfollowing
    case currentUser
    
    var backgroundColor: UIColor {
        switch self {
        case .unfollowing:
            return .twitterBlue
        default:
            return .white
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .unfollowing:
            return .white
        default:
            return .twitterBlue
        }
    }
    
    var title: String {
        switch self {
        case .unfollowing:
            return "Follow"
        case .following:
            return "Following"
        case .loading:
            return "Loading"
        case .currentUser:
            return "Edit Profile"
        }
    }
}
