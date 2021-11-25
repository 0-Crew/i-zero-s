//
//  ChallengeTitleView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/25.
//

import UIKit

class ChallengeTitleView: UIView {

    @IBOutlet weak var challengeDateLabel: UILabel!
    @IBOutlet weak var challengeStateLabel: UILabel!
    @IBOutlet weak var challengeSubjectLabel: UILabel!
    @IBOutlet weak var subjectView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("ChallengeTitleView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }
        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
    }

    internal func setLabel(date: String, state: Bool, subject: String, color: UIColor) {
        challengeDateLabel.text = date
        challengeDateLabel.textColor = color
        challengeStateLabel.text = state ? "진행 중인 챌린지" : "종료된 챌린지"
        challengeStateLabel.textColor = color.withAlphaComponent(0.5)
        challengeSubjectLabel.text = subject
        subjectView.backgroundColor = color

        if let text = challengeSubjectLabel.text {
            let changeString: String = "|"
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String),
                                       value: UIFont.futuraStd(size: 14, family: .bold),
                                       range: (text as NSString).range(of: changeString))
            attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String),
                                       value: UIFont.spoqaHanSansNeo(size: 14, family: .bold),
                                       range: (text as NSString).range(of: subject))
            challengeSubjectLabel.attributedText = attributedStr
        }
    }
}
