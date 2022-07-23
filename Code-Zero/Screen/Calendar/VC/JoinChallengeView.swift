//
//  JoinChallengeView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/19.
//

import UIKit

class JoinChallengeView: UIView { // 새로운 챌린지 참여하기 View

    // MARK: - Property
    var user: Bool = true
    var joinChallenge: (() -> Void)?

    // MARK: - @IBOutlet
    @IBOutlet weak var joinButton: UIButton!

    @IBAction func joinButtonDidTap(_ sender: UIButton) {
        guard let joinChallenge = joinChallenge else {
            return
        }
        joinChallenge()
    }
    // MARK: - init Function
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    init(frame: CGRect, isUser: Bool, join: (() -> Void)?) {
        self.user = isUser
        self.joinChallenge = join
        super.init(frame: frame)
        loadView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - View Layout Function
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("JoinChallengeView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }

        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
        if !user {
            setFollowerView()
        }
    }
    private func setFollowerView() {
        joinButton.setButton(text: "새로운 챌린지를 기다리는 중",
                             color: .white,
                             font: .spoqaHanSansNeo(size: 16, family: .bold),
                             backgroundColor: .clear)
        joinButton.setImage(nil, for: .normal)
        joinButton.isSelected = false
    }
}
