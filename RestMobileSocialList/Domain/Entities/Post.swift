//
//  Post.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: Int
    let userAvatar: String
    let userName: String
    let postDate: String
    let postTitle: String
    let postDescr: String
    let postThumbnail: String
    let comments: [PostComment]
    let like: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, userAvatar, userName, postDate, postTitle, postDescr, postThumbnail, comments, like
    }
}

struct PostComment: Identifiable, Codable {
    let id: String
    let name: String
    let text: String
}

struct PostsResponse: Codable {
    let posts: [Post]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        posts = try container.decode([Post].self)
    }
}
