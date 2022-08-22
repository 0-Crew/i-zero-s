//
//  DeleteUserService.swift
//  Code-Zero
//
//  Created by 미니 on 2022/07/11.
//

import Foundation

struct DeleteUser: Codable {
    let user: DeleteUserInfo
}

struct DeleteUserInfo: Codable {
    let id: Int
    let isDeleted: Bool
    let provider: String
}
