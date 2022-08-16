//
//  UncompletedChallengeFinalVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/08/16.
//

import UIKit

class UncompletedChallengeFinalVC: UIViewController {

    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var takeRainCheckView: UIView!

    internal var myChallenge: UserChallenge?
    internal var userNickname: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    private func initView() {
        nickNameLabel.text = "\(userNickname)님,"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        takeRainCheckView.addGestureRecognizer(tapGesture)
    }

    @objc func dismissVC() {
        guard let accessToken = accessToken, let myChallengeId = myChallenge?.id else { return }
        Indicator.shared.show()
        MainChallengeService.shared.requestEmptyBottle(
            token: accessToken,
            myChallengeId: myChallengeId
        ) { result in
            switch result {
            case .success(let isSuceess):
                if isSuceess {
                    let rootViewController = UIApplication.shared.windows.first?.rootViewController
                    guard
                        let navigationController = rootViewController as? UINavigationController,
                        let challengeVC = navigationController.topViewController as? ChallengeVC
                    else { return }
                    challengeVC.fetchMyChallenge()
                    challengeVC.dismiss(animated: false)
                }
            default:
                break
            }
            Indicator.shared.dismiss()
        }
    }
}
