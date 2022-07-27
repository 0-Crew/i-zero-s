//
//  BottleWorldUser.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/27.
//

import Foundation

// MARK: - BottleWorldUser
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
