//
//  Post.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import Foundation

struct Post: Identifiable, Codable {
    var id = UUID()
    let date: String
    let title: String
    let descr: String 
    let avatar: String
    let thumbnail: String
    let comments: [PostComment]
    let like: Int
    
    static func mockData() -> [Post] {
        [
            Post(date: "01.01.2025",
                 title: "Title 1",
                 descr: "Description 1",
                 avatar: "avatar",
                 thumbnail: "thumbnail",
                 comments: [
                    PostComment(name: "Name 1", text: "Text 1"),
                    PostComment(name: "Name 2", text: "Text 2")
                 ],
                 like: 2)
        ]
    }
}

struct PostComment: Identifiable, Codable {
    var id = UUID()
    let name: String
    let text: String
}
