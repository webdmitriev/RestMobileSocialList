//
//  FetchPostsUseCase.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 07.07.2025.
//

import Foundation
import Combine

protocol FetchPostsUseCase {
    func execute() -> AnyPublisher<[Post], Error>
}

class FetchPostsUseCaseImpl: FetchPostsUseCase {
    
    let repository: FetchPostRepository
    init(repository: FetchPostRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Post], any Error> {
        self.repository.fetchPosts()
    }
    
    
}
