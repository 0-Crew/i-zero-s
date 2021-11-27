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
                                        .blueCalendar, .purpleCalendar, .pinkCalender, .orangeMain]

    // MARK: - IBOutlet
    @IBOutlet weak var bottleImageView: UIImageView!
    @IBOutlet weak var challengeTitleView: UIView!
    @IBOutlet weak var challengeListStackView: UIStackView!
    @IBOutlet weak var lineView: UIView!

    required init(frame: CGRect, color: Int, date: String, subject: String, list: [DayChallengeState]) {
        super.init(frame: frame)
        loadView()
        setTitleView(date: date, subject: subject, color: colorChip[color], list: list)
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
        lineView.setGradient(
            startColor: .orangeMain,
            endColor: .gray1
        )
    }

    private func setTitleView(date: String, subject: String, color: UIColor, list: [DayChallengeState]) {
        let challengeTitleView = ChallengeTitleView(frame: .zero)
        self.challengeTitleView.addSubview(challengeTitleView)
        challengeTitleView.setLabel(date: date,
                                    state: color == .orangeMain,
                                    subject: subject,
                                    color: color)
        self.challengeTitleView.backgroundColor = .none

        if color != .orangeMain { // 현재 진행중인 챌린지가 아닐 때
            challengeTitleView.snp.remakeConstraints {
                bottleImageView.snp.removeConstraints()
                lineView.snp.removeConstraints()
                $0.leading.equalTo(self.snp.leading)
                $0.trailing.equalTo(self.snp.trailing)
                $0.height.equalTo(58)
            }

            bottleImageView.removeFromSuperview()
            lineView.removeFromSuperview()

            challengeListStackView.snp.remakeConstraints {
                $0.leading.equalTo(self.snp.leading).offset(10)
                $0.trailing.equalTo(self.snp.trailing).offset(-10)
            }

            challengeListStackView.arrangedSubviews.enumerated().forEach {
                let challengedListView = ChallengedListView(frame: .zero)
                $0.element.backgroundColor = .none
                $0.element.addSubview(challengedListView)
                challengedListView.setChallengeList(completed: list[$0.offset].sucess,
                                                    challengeText: list[$0.offset].title)
                challengedListView.snp.remakeConstraints {
                    $0.width.equalTo(self.challengeListStackView.snp.width)
                    $0.height.equalTo(self.challengeListStackView.arrangedSubviews[0].frame.height)
                }
            }

        } else { // 현재 진행중인 챌린지일 때
            challengeTitleView.snp.remakeConstraints {
                $0.leading.equalTo(self.bottleImageView.snp.trailing).offset(26)
                $0.trailing.equalTo(self.snp.trailing)
                $0.height.equalTo(58)
            }

            challengeListStackView.arrangedSubviews.enumerated().forEach {
                let challengingListView = ChallengingListView(frame: .zero)
                $0.element.backgroundColor = .none
                $0.element.addSubview(challengingListView)
                challengingListView.setChallengeList(completed: list[$0.offset].sucess,
                                                     challengeText: list[$0.offset].title)
                challengingListView.snp.remakeConstraints {
                    $0.width.equalTo(self.challengeListStackView.snp.width)
                    $0.height.equalTo(self.challengeListStackView.arrangedSubviews[0].frame.height)
                    $0.leading.equalTo(self.snp.leading).offset(3)

                }
            }
        }
    }
}
