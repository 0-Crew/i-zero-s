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

extension Convenience {

    func getDueDate(challengeStartDate: Date) -> Date? {
        guard let day = day else { return nil }
        return challengeStartDate.getDateIntervalBy(intervalDay: day - 1)
    }

    func isToday(challengeStartDate: Date) -> Bool {
        guard let dueDate = getDueDate(challengeStartDate: challengeStartDate) else {
            return false
        }

        return dueDate.isToday
    }
    func mapChallengeState(challengeStartDate: Date) -> ChallengeState? {
        guard
            let isFinished = isFinished,
            let dueDate = getDueDate(challengeStartDate: challengeStartDate)
        else { return nil }
        if isToday(challengeStartDate: challengeStartDate) {
            return isFinished ? .challengingCompleted : .challengingNotCompleted
        }

        if Date() > dueDate {
            return isFinished ? .didChallengeCompleted : .didChallengeNotCompleted
        }

        return .willChallenge
    }
    func mapFinalChallengeViewState() -> FinalChallengeViewState? {
        guard let isFinished = isFinished else { return nil }
        return isFinished ? .challengeComplete : .challengeNotComplete
    }
}
