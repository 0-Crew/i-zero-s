//
//  MyInconvenience.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/02/21.
//

import Foundation

// MARK: - Convenience
struct Convenience: Codable {
    let id: Int
    let name, createdAt, updatedAt: String
    let isDeleted: Bool
    let myChallengeID: Int?
    let day: Int?
    let isFinished: Bool?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, createdAt, updatedAt, isDeleted
        case myChallengeID = "myChallengeId"
        case day, isFinished
        case userID = "userId"
    }

    var dayChallengeState: DayChallengeState {
        return DayChallengeState(title: name, sucess: isFinished ?? false)
    }
}
