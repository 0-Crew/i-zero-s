//
//  UIViewController+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/31.
//

import UIKit
import SafariServices

extension UIViewController {
    /// Device Height ratio via zeplin view
    var deviceHeightRatio: CGFloat {
        return UIScreen.main.bounds.height / 812.0
    }

    /// Device Width ratio via zeplin view
    var deviceWidthRatio: CGFloat {
        return UIScreen.main.bounds.width / 375.0
    }

    /// Access Token
    var accessToken: String? {
        return UserDefaultManager.shared.accessToken
    }

    /// Provider
    var provider: String? {
        return UserDefaultManager.shared.provider
    }

}

extension UIViewController {
    // UIAlertController without handler
    func simpleAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    // UIAlertController with Handler
    func simpleAlertwithHandler(title: String,
                                message: String,
                                okHandler: ((UIAlertAction) -> Void)?,
                                cancleHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancleHandler)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    // Set NavigationBar Background Clear without underline
    func setNavigationBarClear() {
        let navigationBar: UINavigationBar! = self.navigationController?.navigationBar

        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
    }

    // Set NavigationBar Background Clear with underline
    func setNavigationBarShadow() {
        let navigationBar: UINavigationBar! = self.navigationController?.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.backgroundColor = UIColor.white
    }

    func presentSafariWebVC(url string: String) {
      if let URL = URL(string: string) {
        let viewController = SFSafariViewController(url: URL)
        present(viewController, animated: true)
      }
    }

    // 두번이상 navigation pop을 연속으로 하고 싶을 때 사용
    func navigationPopBack(_ number: Int) {
        if let viewControllers: [UIViewController] = navigationController?.viewControllers {
            guard viewControllers.count < number else {
                navigationController?.popToViewController(viewControllers[viewControllers.count - number],
                                                               animated: true)
                return
            }
        }
    }
}
