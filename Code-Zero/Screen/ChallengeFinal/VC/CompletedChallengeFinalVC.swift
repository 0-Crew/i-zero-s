//
//  CompletedChallengeFinalVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/08/09.
//

import UIKit
import Lottie
import SnapKit

class CompletedChallengeFinalVC: UIViewController {

    @IBOutlet weak var challengeSuccessView: UIView!
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var newChallengeButton: UIButton!
    private var animationView: AnimationView = AnimationView(name: "challenge_congratulate")

    internal var myChallenge: UserChallenge?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        challengeNameLabel.text = "\(myChallenge?.name ?? "") 대신\n7번의 불편함을 참아냈어요"
        newChallengeButton.setBorder(borderColor: .orangeMain, borderWidth: 1.0)
        challengeSuccessView.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        animationView.play()
    }

    @IBAction func newChallengeButtonDidTap(_ sender: Any) {
        guard let accessToken = accessToken, let myChallengeId = myChallenge?.id else { return }
        Indicator.shared.show()
        MainChallengeService.shared.requestEmptyBottle(
            token: accessToken,
            myChallengeId: myChallengeId) { result in
                switch result {
                case .success(let isSuccess):
                    if isSuccess {
                        let rootViewController = UIApplication.shared.windows.first?.rootViewController
                        rootViewController?.dismiss(animated: true)
                    }
                default:
                    break
                }
                Indicator.shared.dismiss()
            }
    }

}
