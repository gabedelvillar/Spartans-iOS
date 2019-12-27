//
//  BaseTabBarController.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 11/29/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeController = HomeController()
        let homeNavController = UINavigationController(rootViewController: homeController)
        homeNavController.navigationBar.prefersLargeTitles = true
        homeController.navigationItem.title = "Spartans"
        homeController.view.backgroundColor = .white
        homeNavController.tabBarItem.title = "Spartans"
        
        let settingsController = SettingsController()
        settingsController.delegate = homeController
        let settingsNavController = UINavigationController(rootViewController: settingsController)
        settingsNavController.navigationBar.prefersLargeTitles = true
        settingsController.navigationItem.title = "Settings"
        settingsController.view.backgroundColor = .white
        settingsNavController.tabBarItem.title = "Settings"
        
        
        viewControllers = [
            
            homeNavController,
            createNavController(viewController: MatchesMessagesController(), title: "Messages"),
            createNavController(viewController: ActivityController(), title: "Activity"),
            settingsNavController
            
        ]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .gray
        navController.tabBarItem.title = title
        
        return navController
    }
}
