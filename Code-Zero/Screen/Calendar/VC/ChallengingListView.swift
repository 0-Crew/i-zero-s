//
//  ChallengingListView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/25.
//

import UIKit

class ChallengingListView: UIView {

    @IBOutlet weak var completedImageView: UIImageView!
    @IBOutlet weak var challengeLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("ChallengingListView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }
        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
    }

    internal func setChallengeList(completed: Bool, challengeText: String) {
        completedImageView.image = completed ?
        UIImage(named: "icMiniWaterNone") : UIImage(named: "icMiniWaterSuccess")
        challengeLabel.text = challengeText
    }
}
