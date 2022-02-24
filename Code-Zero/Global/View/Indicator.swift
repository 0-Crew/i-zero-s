//
//  Indicator.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/02/21.
//

import UIKit
import Lottie

class Indicator {
    static let shared = Indicator()

    private var indicatorView: UIActivityIndicatorView
    private var backgorundView: UIView

    private let width: CGFloat = 32
    private let height: CGFloat = 32

    let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

    init() {
        let rootView = keyWindow?.rootViewController?.view

        let center = rootView?.center ?? CGPoint(x: 0, y: 0)
        let indicatorX = center.x - width / 2
        let indiciatorY = center.y - height / 2
        let indicatorFrame = CGRect(x: indicatorX, y: indiciatorY, width: width, height: height)
        indicatorView = .init(frame: indicatorFrame)
        indicatorView.style = .medium
        backgorundView = UIView(
            frame: CGRect(x: 0, y: 0, width: rootView?.frame.width ?? 0, height: rootView?.frame.height ?? 0)
        )
        backgorundView.backgroundColor = .black.withAlphaComponent(0.5)
    }

    func show() {
        DispatchQueue.main.async {
            self.indicatorView.startAnimating()
            if var topViewController = self.keyWindow?.rootViewController,
               let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController

                topViewController.view.addSubview(self.backgorundView)
                topViewController.view.addSubview(self.indicatorView)
            }
        }
    }

    func dismiss() {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            self.backgorundView.removeFromSuperview()
            self.indicatorView.removeFromSuperview()
        }
    }

}
