//
//  Models.swift
//  InstagramStoryboard
//
//  Created by Shubham Kumar on 01/03/22.
//

import UIKit
public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

public enum Gender {
    case male, female, other
}

/// User Post

struct User {
    let username: String
    let name: (first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let profilePhoto: URL
    let bio: String
    let counts: UserCount
    let joinDate: Date
    
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL
    let caption: String?
    let likeCount: [PostLike]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUser: [String]
    let owner: User
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
    let identifier: String
}
