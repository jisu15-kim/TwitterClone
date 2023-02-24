//
//  NotificationsController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit

class NotificationsController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }
    
}
