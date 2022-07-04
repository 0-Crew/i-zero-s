//
//  SplashVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/07/05.
//

import UIKit
import Lottie
import SnapKit

class SplashVC: UIViewController {

    // MARK: - Property
    private let animationView = AnimationView(name: "loading")

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orangeMain
    }
    override func viewDidAppear(_ animated: Bool) {
        settingSplashLottie()
    }

    // MARK: - Set Lottie
    private func settingSplashLottie() {
        animationView.contentMode = .scaleToFill
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(120)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    private func runSplashLottie() {
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            switch finished {
            case true:
                self.checkIsUser()
            case false:
                self.runSplashLottie()
            }
        })
    }

    // MARK: - Check User
    private func checkIsUser() {
        let isUser: Bool = UserDefaultManager.shared.accessToken != nil
        changeRootViewController(isUser)
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
