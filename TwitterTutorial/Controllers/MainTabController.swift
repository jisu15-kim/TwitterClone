//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        uiTabBarSetting()
        configureViewControllers()
    }
    
    //MARK: - Helpers
    func uiTabBarSetting() {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray5
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
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
}
