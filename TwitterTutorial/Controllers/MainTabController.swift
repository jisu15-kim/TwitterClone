//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import Firebase
import SnapKit

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = self.user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(nil, action: #selector(ActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    //MARK: - API
    func fetchUser() {
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: 로그인 상태가 아닙니다")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            print("DEBUG: 로그인 되었습니다")
            uiTabBarSetting()
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            authenticateUserAndConfigureUI()
        } catch let error {
            print("DEBUG: 로그아웃에 실패했어요 \(error)")
        }
    }
    
    //MARK: - Selectors
    @objc func ActionButtonTapped() {
//        logUserOut()
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: UploadTweetController(user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(actionButton)
        
        actionButton.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(64)
            $0.trailing.equalTo(view).inset(16)
        }
        
        actionButton.layer.cornerRadius = 56 / 2
        actionButton.clipsToBounds = true
    }
    
    func configureViewControllers() {
        
        let feed = FeedController()
        let nav1 = templateNavigationController("home_unselected", viewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController("search_unselected", viewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController("like_unselected", viewController: notifications)
        
        let conversations = ConverstaionsController()
        let nav4 = templateNavigationController("ic_mail_outline_white_2x-1", viewController: conversations)
        
        viewControllers = [nav1, nav2, nav3, nav4]
        
        tabBar.backgroundColor = .systemGray5
        tabBar.isTranslucent = true
        tabBar.alpha = 0.95
    }
    
    func templateNavigationController(_ image: String, viewController:UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.image = UIImage(named: image)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray5
        nav.navigationBar.standardAppearance = appearance;
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        return nav
    }
    
    func uiTabBarSetting() {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray5
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
