//
//  ViewController.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/11.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var onboardingButton: UIButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    @IBAction func onboardingButtonDidTap() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard
            let onboardingStepOneVC = storyboard.instantiateViewController(
                withIdentifier: "OnboardingStepOneVC"
            ) as? OnboardingStepOneVC else { return }
        navigationController?.pushViewController(onboardingStepOneVC, animated: true)
    }

    @IBAction func kakaoSignInButtonDidTap() {
        changeRootViewToChallenge()
    }
    @IBAction func appleSignInButtonDidTap() {
        changeRootViewToChallenge()
    }

}

extension HomeVC {
    private func initView() {
        appTitleLabel.setTextWithLineHeight(lineHeight: 54)
        appTitleLabel.setTextLetterSpacing(letterSpacing: 1.35)
        appDescriptionLabel.setTextWithLineHeight(lineHeight: 21)

        onboardingButton.setBorder(borderColor: .white, borderWidth: 1.0)
    }
    private func changeRootViewToChallenge() {
        let storybard = UIStoryboard(name: "Challenge", bundle: nil)
        let challengeNavigationVC = storybard.instantiateViewController(withIdentifier: "Challenge")
        UIApplication.shared.windows.first?.replaceRootViewController(
            challengeNavigationVC,
            animated: true,
            completion: nil
        )
    }
}
