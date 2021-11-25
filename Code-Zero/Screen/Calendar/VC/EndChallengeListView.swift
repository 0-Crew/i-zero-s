//
//  EndChallengeListView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/25.
//

import UIKit

class EndChallengeListView: UIView {

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
        guard let view = Bundle.main.loadNibNamed("EndChallengeListView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }
        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
    }

    internal func setChallengeList(completed: Bool, challengeText: String) {
        if completed {
            completedImageView.image = UIImage(named: "checkbox")
            challengeLabel.font = .spoqaHanSansNeo(size: 12, family: .medium)
            challengeLabel.textColor = .lightGray3
            challengeLabel.text = challengeText
        } else {
            completedImageView.image = UIImage(named: "nonCheckbox")
            challengeLabel.font = .spoqaHanSansNeo(size: 12, family: .regular)
            challengeLabel.textColor = .gray2
            challengeLabel.attributedText = challengeText.strikeThrough()
        }
    }

}

extension String { // 취소선 긋기
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: .init(location: 0, length: attributeString.length))
        return attributeString
    }
}
