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
        
        viewControllers = [
            
            createNavController(viewController: UIViewController(), title: "Spartans"),
            createNavController(viewController: UIViewController(), title: "Messages"),
            createNavController(viewController: UIViewController(), title: "Activity"),
            createNavController(viewController: UIViewController(), title: "Settings")
            
        ]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        
        return navController
    }
}
