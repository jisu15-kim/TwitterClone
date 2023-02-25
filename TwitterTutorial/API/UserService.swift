//
//  UserService.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            // snapshot은 딕셔너리로 변환하여 사용
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            print("Dictionary: \(dictionary)")
            
            // User 객체 생성
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
