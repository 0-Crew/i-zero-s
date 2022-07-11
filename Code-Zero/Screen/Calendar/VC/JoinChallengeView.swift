//
//  JoinChallengeView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/19.
//

import UIKit

class JoinChallengeView: UIView { // 새로운 챌린지 참여하기 View

    var user: Bool = true
    
    @IBOutlet weak var joinButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    init(frame: CGRect, isUser: Bool) {
        self.user = isUser
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

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
