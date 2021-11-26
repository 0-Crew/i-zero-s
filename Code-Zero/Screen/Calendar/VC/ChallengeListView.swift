//
//  ChallengeListView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/25.
//

import UIKit
import SnapKit

class ChallengeListView: UIView {

    private let colorChip: [UIColor] = [.yellowCalendar, .greenCalendar, .redCalendar,
                                        .blueCalendar, .purpleCalendar, .pinkCalender]

    // MARK: - IBOutlet
    @IBOutlet weak var bottleImageView: UIImageView!
    @IBOutlet weak var challengeTitleView: UIView!
    @IBOutlet weak var challengeListStackView: UIStackView!
    @IBOutlet weak var lineView: UIView!

    required init(frame: CGRect, color: Int, date: String, subject: String, list: [String]) {
        super.init(frame: frame)
        loadView()
        setTitleView(date: date, subject: subject, color: colorChip[color])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("ChallengeListView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }
        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
    }

    private func setTitleView(date: String, subject: String, color: UIColor) {
        let challengeTitleView = ChallengeTitleView(frame: .zero)
        self.challengeTitleView.addSubview(challengeTitleView)
        challengeTitleView.setLabel(date: date,
                                    state: color == .orangeMain,
                                    subject: subject,
                                    color: color)
        challengeTitleView.snp.makeConstraints {
            $0.width.equalTo(self.challengeTitleView.snp.width)
            $0.height.equalTo(self.challengeTitleView.snp.height)
        }
        self.challengeTitleView.backgroundColor = .none

        if color != .orangeMain { // 현재 진행중인 챌린지가 아닐 때
            challengeTitleView.snp.remakeConstraints {
                $0.leading.equalTo(self.snp.leading)
                $0.trailing.equalTo(self.snp.trailing)
                $0.height.equalTo(58)
            }

            bottleImageView.removeFromSuperview()
            lineView.removeFromSuperview()
        } else {

        }
    }
}
