//
//  FetchPostsRepositoryImpl.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 07.07.2025.
//

import Foundation
import Combine

class FetchPostsRepositoryImpl: FetchPostRepository {
    
    private let dataSource: FetchPostDataSource
    init(dataSource: FetchPostDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPosts() -> AnyPublisher<[Post], any Error> {
        self.dataSource.getPosts()
    }
    
    
}
