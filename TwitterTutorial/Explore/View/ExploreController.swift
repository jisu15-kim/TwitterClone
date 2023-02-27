//
//  ExploreController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import Combine

private let reuseIdentifier = "UserCell"

class ExploreController: UITableViewController {
    
    //MARK: - Properties
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: ExploreViewModel
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - LifeCycle
    init() {
        self.viewModel = ExploreViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
        configureSearchController()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    //MARK: - Bind
    private func bind() {
        viewModel.users
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
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
        searchController.delegate = self
    }
}

//MARK: - TableView DataSource/Delegate
extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTableViewCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = viewModel.getUserDataSource(row: indexPath.row)
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.getUserDataSource(row: indexPath.row)
        let vc = ProfileController(viewModel: ProfileViewModel(user: user))
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - SearchController Delegate
extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Search Keyword
        guard let keyword = searchController.searchBar.text?.lowercased() else { return }
        viewModel.searchKeyword(keyword: keyword)
        print("keyword: \(keyword)")
    }
}

extension ExploreController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        viewModel.inSearchMode = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.inSearchMode = false
    }
}
