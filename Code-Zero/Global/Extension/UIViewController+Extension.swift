//
//  UIViewController+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/31.
//

import UIKit

extension UIViewController {
    /// Device Height ratio via zeplin view
    var deviceHeightRatio: CGFloat {
        return UIScreen.main.bounds.height / 812.0
    }

    /// Device Width ratio via zeplin view
    var deviceWidthRatio: CGFloat {
        return UIScreen.main.bounds.width / 812.0
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
}
