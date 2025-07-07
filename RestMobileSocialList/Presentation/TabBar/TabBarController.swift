//
//  TabBarController.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .appBlack
        self.tabBar.backgroundColor = .appWhite
        self.tabBar.unselectedItemTintColor = .lightGray
        
        setupTabs()
    }
    
    private func setupTabs() {
        let mainVC = self.createNavBar(title: "Главная", image: UIImage(systemName: "house"), vc: Builder.createHomeViewController())
        let favoriteVC = self.createNavBar(title: "Избранное", image: UIImage(systemName: "star"), vc: Builder.createFavoritesViewController())
        
        self.setViewControllers([mainVC, favoriteVC], animated: true)
    }
    
    private func createNavBar(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
    
}
