//
//  JoinChallengeView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/19.
//

import UIKit

class JoinChallengeView: UIView { // 새로운 챌린지 참여하기 View

    @IBOutlet weak var joinButton: UIButton!

    override init(frame: CGRect) {
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
        addSubview(view)
    }

}
