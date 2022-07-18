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

    // MARK: - Token
    internal var accessToken: String? {
        return  UserDefaults.standard.string(forKey: "accessToken")
    }

    internal func saveAccessToken(accessToken token: String?) {
        guard let token = token else { return }

        UserDefaults.standard.set(token, forKey: "accessToken")
    }

    internal func removeAccessToken() {
        if accessToken != nil {
            UserDefaults.standard.removeObject(forKey: "accessToken")
        }
    }

    // MARK: - Provider
    internal var provider: String? {
        return  UserDefaults.standard.string(forKey: "provider")
    }

    internal func saveProvider(provider: String) {
        UserDefaults.standard.set(provider, forKey: "provider")
    }

    internal func removeProvider() {
        if provider != nil {
            UserDefaults.standard.removeObject(forKey: "provider")
        }
    }
}
