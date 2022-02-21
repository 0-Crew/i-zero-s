//
//  AppDelegate.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/11.
//

import UIKit
import AuthenticationServices
import Gedatsu

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
            // Override point for customization after application launch.
            Gedatsu.open()
            if let appleUser = UserDefaults.standard.string(forKey: "appleId") { // 애플 유저라면
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: appleUser) { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        // 인증성공 상태 - > 홈(메인) 화면으로 이동?
                        break
                    case .revoked:
                        // 인증만료 상태 -> 다시 로그인 하는 화면으로 이동
                        UserDefaults.standard.removeObject(forKey: "appleId")
                    default:
                        break
                    }
                }
            }
            return true
        }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            // Called when a new scene session is being created.
            // Use this method to select a configuration to create the new scene with.
            return UISceneConfiguration(name: "Default Configuration",
                                        sessionRole: connectingSceneSession.role)
        }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
