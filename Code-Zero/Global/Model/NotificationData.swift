//
//  NotificationData.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/07/23.
//

import Foundation

struct MyNotificationData: Codable {
    let myNotifications: [NotificationData]
}

struct NotificationData: Codable {
    let id, notificationID, userID, receiverUserID: Int
    let isDeleted: Bool
    let updatedAt, createdAt: String
    let isButtonClicked, isButtonEnabled: Bool
    let content: String
    let buttonText: String?
    let notificationName, notiText: String
    let sentUser: User

    enum CodingKeys: String, CodingKey {
        case id
        case notificationID = "notificationId"
        case userID = "userId"
        case receiverUserID = "receiverUserId"
        case isDeleted, updatedAt, createdAt, isButtonClicked, isButtonEnabled, content,
             buttonText, notificationName, notiText, sentUser
    }
}

extension NotificationData {
    var alarmType: AlarmType {
        switch self.notificationName {
        case "following", "followed":
            return .normal
        case "challenge_start":
            return .cheer
        case "challenge_success":
            return .congrats
        case "congrats":
            return .beCongratulated
        case "cheer":
            return .beCheered
        default:
            return .normal
        }
    }
}
