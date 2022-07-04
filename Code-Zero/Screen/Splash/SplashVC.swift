//
//  SplashVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/06/28.
//

import UIKit
import Lottie
import SnapKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orangeMain
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {

        let animationView = AnimationView(name: "onboarding")
        animationView.contentMode = .scaleToFill
        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.width.equalTo(59)
            $0.height.equalTo(89)
            $0.centerX.centerY.equalToSuperview()
        }
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            if finished {
                print("hi")
            } else {
                // 앱 다시 확인
            }
        })

    }

}
