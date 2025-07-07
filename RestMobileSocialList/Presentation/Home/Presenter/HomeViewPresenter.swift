//
//  HomeViewPresenter.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import Foundation
import Combine

protocol HomeViewPresenterProtocol: AnyObject {
    var view: HomeViewControllerProtocol? { get set }
    func fetchPosts()
}

class HomeViewPresenter: HomeViewPresenterProtocol {
    weak var view: HomeViewControllerProtocol?
    
    private let dataSource: FetchPostDataSource
    private var cancellables: Set<AnyCancellable> = []
    
    init(view: HomeViewControllerProtocol? = nil, dataSource: FetchPostDataSource = RemotePostDataSourceImpl()) {
        self.view = view
        self.dataSource = dataSource
    }
    
    func fetchPosts() {
        dataSource.getPosts()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] posts in
                self?.view?.displayPosts(posts)
            })
            .store(in: &cancellables)
    }
}
