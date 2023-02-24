//
//  User.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import Foundation

struct User {
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    
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
