//
//  UserDefaultManager.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/06/26.
//

import Foundation

class UserDefaultManager {

    static let shared = UserDefaultManager()

    private init () { }

    internal var accessToken: String? {
        return  UserDefaults.standard.string(forKey: "accessToken")
    }

    internal func saveAccessToken(accessToken token: String?) {
        guard let token = token else { return }

        UserDefaults.standard.set(token, forKey: "accessToken")
    }

    internal func removeAccessToken(accessToken token: String?) {
        if accessToken != nil {
            UserDefaults.standard.removeObject(forKey: "accessToken")
        }
    }

}
