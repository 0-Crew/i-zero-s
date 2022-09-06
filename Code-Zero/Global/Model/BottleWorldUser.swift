//
//  BottleWorldUser.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/27.
//

import Foundation

// MARK: - BottleWorldUser
struct BottleWorldBrowse: Codable {
    let users: [BottleWorldUser]
    let count: Count
}

struct BottleWorldFollower: Codable {
    let followers: [BottleWorldUser]
    let count: Count
}

struct BottleWorldFollowing: Codable {
    let followings: [BottleWorldUser]
    let count: Count
}

struct BottleWorldUser: Codable {
    let user: User
    let challenge: UserChallenge?
    var follow: Bool
}

// MARK: - User
struct User: Codable {
    let id: Int
    let name: String
}

// MARK: - Count
struct Count: Codable {
    let follower, following: Int
}
