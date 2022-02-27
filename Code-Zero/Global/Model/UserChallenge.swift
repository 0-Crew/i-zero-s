//
//  UserChallenge.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/02/21.
//

import Foundation

// MARK: - UserChallenge
struct UserChallenge: Codable {
    let id: Int
    let isDeleted: Bool?
    let createdAt, updatedAt, count: String?
    let startedAt: String
    let userID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, isDeleted, createdAt, updatedAt, startedAt
        case userID = "userId"
        case name, count
    }
}
