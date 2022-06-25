//
//  ChallengeVC+KeyboardNotificationSetting.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/06/23.
//

import UIKit

// MARK: - Keyboard Notification Setting
extension ChallengeVC {

    // keyboard가 보여질 때 어떤 동작을 수행
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard
            let offset = editingChallengeOffset,
            let challengeView = challengeViewList[offset]
        else { return }

        let contentOffset: CGPoint = .init(x: 0, y: challengeView.frame.minY)
        scrollView.setContentOffset(contentOffset, animated: true)
    }

    // keyboard가 사라질 때 어떤 동작을 수행
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentOffset: CGPoint = .init(x: 0, y: 0)
        scrollView.setContentOffset(contentOffset, animated: true)
    }

    // observer
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}
