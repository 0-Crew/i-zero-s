//
//  Inconvenience.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/02/21.
//

import Foundation

// MARK: - Inconvenience
struct Inconvenience: Codable {
    let id: Int
    let name: String
    let isDeleted: Bool
    let createdAt, updatedAt: String
}
