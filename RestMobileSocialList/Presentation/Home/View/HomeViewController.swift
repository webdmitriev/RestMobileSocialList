//
//  HomeViewController.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func setupUI()
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {

    var presenter: HomeViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
    }
    
    func setupUI() {
        
    }

}

