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
    let isDeleted, isFinished: Bool?
    let createdAt, updatedAt, count: String?
    let startedAt: String
    let userID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, isDeleted, isFinished, createdAt, updatedAt, startedAt
        case userID = "userId"
        case name, count
    }

    var dates: [(String)] {
        var arrays: [(String)] = []
        guard let days = startedAt.toKoreaData() else { return arrays }
        for index in Range(0...6) {
            guard let day = days.getDateIntervalBy(intervalDay: index)?
                .datePickerToString(format: "yyyy-MM-dd")
            else { return arrays }
            arrays.append(day)
        }
        return arrays
    }
    var startedDate: Date? {
        return startedAt.toDate() ?? nil
    }

    var endedDate: Date? {
        return startedDate?.getDateIntervalBy(intervalDay: 7)
    }

    var isDueDateOver: Bool {
        let tomrrowDate = Date().getDateIntervalBy(intervalDay: 1)
        guard
            let tomrrowDateString = tomrrowDate?.datePickerToString(format: "yyyy-MM-dd")
        else {
            return false
        }
        let endDateString = endedDate?.datePickerToString(format: "yyyy-MM-dd")

        return tomrrowDateString == endDateString
    }
}
