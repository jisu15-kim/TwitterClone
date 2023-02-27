//
//  ExploreController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit

private let reuseIdentifier = "UserCell"

class ExploreController: UITableViewController {
    
    //MARK: - Properties
    private var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var filteredUser: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // 검색중인지 ?
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchUsers()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    private func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
    }
    
    private func setupTableView() {
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    private func getUserResult() -> [User] {
        var users: [User] = []
        if inSearchMode {
            users = self.filteredUser
        } else {
            users = self.users
        }
        return users
    }
}

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getUserResult().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let users = getUserResult()
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let users = getUserResult()
        let controller = ProfileController(user: users[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Search Keyword
        guard let keyword = searchController.searchBar.text?.lowercased() else { return }
        filteredUser = users.filter({
            $0.username.contains(keyword)
        })
    }
}
