//
//  FetchPostRepository.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 07.07.2025.
//

import Foundation
import Combine

protocol FetchPostRepository {
    func fetchPosts() -> AnyPublisher<[Post], Error>
}
