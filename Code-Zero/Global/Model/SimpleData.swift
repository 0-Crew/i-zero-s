//
//  SimpleData.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/20.
//

import Foundation

struct SimpleData: Codable {
    var status: Int
    var success: Bool
    var message: String

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
    }
}
