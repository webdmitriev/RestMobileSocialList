//
//  Post.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import Foundation

struct Post: Identifiable, Codable {
    var id = UUID()
    let userAvatar: String
    let userName: String
    let postDate: String
    let postTitle: String
    let postDescr: String
    let postThumbnail: String
    let comments: [PostComment]
    let like: Int
    
    static func mockData() -> [Post] {
        [
            Post(userAvatar: "gabriella-avatar",
                 userName: "Gabriella Gabriella Gabriella Gabriella",
                 postDate: "01.01.2025",
                 postTitle: "Title 1",
                 postDescr: "Description 1",
                 postThumbnail: "gabriella",
                 comments: [
                    PostComment(name: "Name 1", text: "Text 1"),
                    PostComment(name: "Name 2", text: "Text 2")
                 ],
                 like: 2),
            Post(userAvatar: "gabriella-avatar",
                 userName: "Gabriella Gabriella Gabriella Gabriella",
                 postDate: "01.01.2025",
                 postTitle: "Title 2",
                 postDescr: "Description 1",
                 postThumbnail: "gabriella",
                 comments: [
                    PostComment(name: "Name 1", text: "Text 1"),
                    PostComment(name: "Name 2", text: "Text 2")
                 ],
                 like: 3)
        ]
    }
}

struct PostComment: Identifiable, Codable {
    var id = UUID()
    let name: String
    let text: String
}
