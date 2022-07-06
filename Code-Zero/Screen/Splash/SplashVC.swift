//
//  SplashVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/07/05.
//

import UIKit

class SplashVC: UIViewController {

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orangeMain
    }

    // MARK: - Check User
    private func checkIsUser() {
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
