//
//  UserData.swift
//  Code-Zero
//
//  Created by Hailey on 2022/05/25.
//

import Foundation

// MARK: - SettingData
struct SettingData: Codable {
    let user: UserInfo
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let id: Int
    let name: String
    let isPrivate: Bool
}
