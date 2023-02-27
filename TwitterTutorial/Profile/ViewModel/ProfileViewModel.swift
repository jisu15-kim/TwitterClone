//
//  ProfileViewModel.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/27.
//

import Foundation
import Combine

class ProfileViewModel {
    //MARK: - Properties
    var user: CurrentValueSubject<User, Never>
    var tweets: CurrentValueSubject<[Tweet], Never>

    //MARK: - Lifecycle
    init(user: User) {
        self.user = CurrentValueSubject(user)
        self.tweets = CurrentValueSubject([])
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    //MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user.value) { [weak self] tweets in
            self?.tweets.send(tweets)
        }
    }
    
    func checkIfUserIsFollowed() {
        if !self.user.value.isCurrentUser {
            UserService.shared.checkIfUserIsFollowed(uid: user.value.uid) { [weak self] isFollowed in
                if isFollowed {
                    self?.user.value.followStatus = .following
                } else {
                    self?.user.value.followStatus = .unfollowing
                }
            }
        } else {
            self.user.value.followStatus = .currentUser
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.value.uid) { [weak self] in
            self?.user.value.stats = $0
        }
    }
    
    func profileFollowEditAction() {
        
        if user.value.isCurrentUser {
            print("Edit Profile Tapped")
            return
        }
        
        switch user.value.followStatus {
        case .following:
            UserService.shared.unfollowUser(uid: user.value.uid) { [weak self] (error, ref) in
                self?.user.value.followStatus = .unfollowing
                self?.fetchUserStats()
            }
        case .unfollowing:
            UserService.shared.followUser(uid: user.value.uid) { [weak self] (error, ref) in
                self?.user.value.followStatus = .following
                self?.fetchUserStats()
            }
        default:
            return
        }
    }
    
    //MARK: - Helper
    func getTweetsCellCount() -> Int {
        return tweets.value.count
    }
}
