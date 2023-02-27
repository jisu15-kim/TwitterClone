//
//  ExploreViewModel.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/27.
//

import Foundation
import Combine

class ExploreViewModel {
    //MARK: - Properties
    var users: CurrentValueSubject<[User], Never>
    var everyUser: [User] = []
    var inSearchMode: Bool = false {
        didSet { if !inSearchMode { showEveryResult() } }
    }
    
    //MARK: - Lifecycle
    init() {
        users = CurrentValueSubject([])
        fetchUsers()
    }
    
    //MARK: - API
    private func fetchUsers() {
        UserService.shared.fetchUsers { [weak self] users in
            self?.everyUser = users
            if self?.inSearchMode == false {
                self?.showEveryResult()
            }
        }
    }
    
    //MARK: - Helper
    func showEveryResult() {
        self.users.send(everyUser)
    }
    
    func searchKeyword(keyword: String) {
        if inSearchMode {
            let filteredUser = everyUser.filter({
                $0.username.contains(keyword)
            })
            print("DEBUG, \(filteredUser)")
            self.users.send(filteredUser)
        }
    }
    
    func getTableViewCount() -> Int {
        return users.value.count
    }
    
    func getUserDataSource(row: Int) -> User {
        return users.value[row]
    }
}
