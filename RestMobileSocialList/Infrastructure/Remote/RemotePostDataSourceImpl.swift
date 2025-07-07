//
//  RemotePostDataSourceImpl.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 07.07.2025.
//

import Foundation
import Combine

class RemotePostDataSourceImpl: FetchPostDataSource {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getPosts() -> AnyPublisher<[Post], Error> {
        guard let url = URL(string: "https://api.webdmitriev.com/wp-json/wp/v2/social-posts/") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Post].self, decoder: decoder)
            .map { posts in
                posts.map { $0 }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func mockPosts() -> [Post] {
        [
            Post(id: 01, userAvatar: "gabriella-avatar",
                 userName: "Gabriella Gabriella Gabriella Gabriella",
                 postDate: "01.01.2025",
                 postTitle: "Title 1",
                 postDescr: "Description 1",
                 postThumbnail: "gabriella",
                 comments: [
                    PostComment(id: "011", name: "Name 1", text: "Text 1"),
                    PostComment(id: "012", name: "Name 2", text: "Text 2")
                 ],
                 like: 2),
            Post(id: 02, userAvatar: "gabriella-avatar",
                 userName: "Gabriella Gabriella Gabriella Gabriella",
                 postDate: "01.01.2025",
                 postTitle: "Title 2",
                 postDescr: "Description 1",
                 postThumbnail: "gabriella",
                 comments: [
                    PostComment(id: "021", name: "Name 1", text: "Text 1"),
                    PostComment(id: "022", name: "Name 2", text: "Text 2")
                 ],
                 like: 3)
        ]
    }
}
