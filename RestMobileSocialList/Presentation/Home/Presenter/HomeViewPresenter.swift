//
//  HomeViewPresenter.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import Foundation

protocol HomeViewPresenterProtocol: AnyObject {
    
}

class HomeViewPresenter: HomeViewPresenterProtocol {
    weak var view: HomeViewControllerProtocol?
    
    init(view: HomeViewControllerProtocol?) {
        self.view = view
    }
    
    func setupUI() {
        
    }
    
    
}
