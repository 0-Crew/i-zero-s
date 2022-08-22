//
//  SplashVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/07/05.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class SplashVC: UIViewController {

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orangeMain
        kakaoTokenRefresh()
    }

    // MARK: - Check User
    private func kakaoTokenRefresh() {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { (_, error) in
                if error != nil {
                    UserDefaultManager.shared.removeAccessToken()
                }
            }
        }
        self.checkIsUser()
    }
    private func checkIsUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            let isUser: Bool = UserDefaultManager.shared.accessToken != nil
            self.changeRootViewController(isUser)
        })
    }
    private func changeRootViewController(_ isUser: Bool) {
        let root: String = isUser ? "Challenge" : "Home"
        let storybard = UIStoryboard(name: root, bundle: nil)
        let viewController = storybard.instantiateViewController(withIdentifier: root)
        UIApplication.shared.windows.first?.replaceRootViewController(
            viewController,
            animated: true,
            completion: nil
        )
    }
}
