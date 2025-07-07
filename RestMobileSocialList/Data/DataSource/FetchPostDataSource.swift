//
//  FetchPostDataSource.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 07.07.2025.
//

import Foundation
import Combine

protocol FetchPostDataSource {
    func getPosts() -> AnyPublisher<[Post], Error>
    func mockPosts() -> [Post]
}
