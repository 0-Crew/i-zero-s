//
//  Dummy.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/17.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {

    let status: Int
    let success: Bool
    let message: String
    let data: T?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}
