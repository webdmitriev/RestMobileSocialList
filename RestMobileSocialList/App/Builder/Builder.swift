//
//  Builder.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit

class Builder {
    // OnboardingView
    static func createOnboardingViewController() -> UIViewController {
        let view = OnboardingViewController()
        return view
    }
    
    // HomeView
    static func createHomeViewController() -> UIViewController {
        let view = HomeViewController()
        let presenter = HomeViewPresenter(view: view) 
        view.presenter = presenter
        return view
    }
}
