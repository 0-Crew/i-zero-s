//
//  OnboardingStepFourVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/01/25.
//

import UIKit
import Lottie
import SnapKit

class OnboardingStepFourVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var startChallengeButton: UIButton!

    override func viewDidLoad() {
        initView()
    }
    private func initView() {
        animationView.play()
        linkLabel.setUnderLineBoldFontWithLink(in: ["이용약관", "개인정보정책"])
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(linkLabelDidTap(_:))
        )
        linkLabel.addGestureRecognizer(tapGestureRecognizer)
        animationView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(76*deviceHeightRatio)
        }
        startChallengeButton.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(74*deviceHeightRatio)
        }
    }

    // MARK: - IBAction
    @IBAction func linkLabelDidTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: linkLabel)

        // fixedLabel 내에서 문자열 google이 차지하는 CGRect값을 구해, 그 안에 point가 포함되는지를 판단합니다.
        if let useTermRect = linkLabel.boundingRectForCharacterRange(subText: "이용약관"),
           useTermRect.contains(point) {
            presentSafariWebVC(url: Constants.userTermURL)
        }
        if let privacyTermRect = linkLabel.boundingRectForCharacterRange(subText: "개인정보정책"),
           privacyTermRect.contains(point) {
            presentSafariWebVC(url: Constants.privacyTermURL)
        }
    }

    @IBAction func startChallengeButtonDidTap(_ sender: Any) {
        let storybard = UIStoryboard(name: "Challenge", bundle: nil)
        let challengeNavigationVC = storybard.instantiateViewController(withIdentifier: "Challenge")
        UIApplication.shared.windows.first?.replaceRootViewController(
            challengeNavigationVC,
            animated: true,
            completion: nil
        )
    }
}
