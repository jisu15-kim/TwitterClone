//
//  AuthService.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        // 이미지 업로드
        storageRef.putData(imageData, metadata: nil) {(meta, error) in
            
            // 이미지 다운로드
            storageRef.downloadURL { (url, error) in
                // URL 가져오기
                guard let profileImageUrl = url?.absoluteString else { return }
                // Firebase 로그인 Auth
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return // 에러가 있으면 함수 종료
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email" : email,
                                  "username" : username,
                                  "fullname" : fullname,
                                  "profileImageUrl" : profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
