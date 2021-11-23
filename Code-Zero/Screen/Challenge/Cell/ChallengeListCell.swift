//
//  ChallengeListCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/20.
//

import UIKit
import SnapKit

protocol ChallengeListCellDelegate: AnyObject {
    func didCalendarButtonTap()
}
class ChallengeListCell: UICollectionViewCell {
    static let identifier = "ChallengeListCell"

    // MARK: - IBOutlet
    @IBOutlet weak var bottleImageView: UIImageView!
    @IBOutlet weak var initialLineView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var challengeListStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }

    // MARK: - Property
    private var bottleImageLists: [UIImage?] = (0...7).map { "icBottleMain\($0)" }
    .map { UIImage(named: $0)}

    var challengeStateList: [ChallengeState] = [
        .didChallengeCompleted,
        .didChallengeCompleted,
        .didChallengeNotCompleted,
        .didChallengeCompleted,
        .didChallengeNotCompleted,
        .didChallengeNotCompleted,
        .challengingNotCompleted
    ] {
        didSet {
            updateBottleImageView(stateList: challengeStateList)
        }
    }
    weak var delegate: ChallengeListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    private func initView() {
        lineView.setGradient(
            startColor: .orangeMain,
            endColor: UIColor(red: 70, green: 65, blue: 57)
        )
        challengeListStackView.arrangedSubviews.enumerated().forEach {
            let challengView = $0.element as? ChallengeView
            challengView?.delegate = self
            challengView?.setChallengeState(state: challengeStateList[$0.offset])
            challengView?.challengeOffset = $0.offset
        }
        updateBottleImageView(stateList: challengeStateList)
    }

    private func updateBottleImageView(stateList: [ChallengeState]) {
        let remainCount = 7 - stateList
            .filter {
                $0 == .willChallenge || $0 == .challengingNotCompleted || $0 == .didChallengeNotCompleted
            }
            .count

        bottleImageView.image = bottleImageLists[remainCount]
    }

    @IBAction func calendarButtonDidTap(sender: UIButton) {
        delegate?.didCalendarButtonTap()
    }
}

extension ChallengeListCell: ChallengeViewDelegate {
    func didEditButtonTap(challengeOffset: Int) {

    }

    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState) {
        challengeStateList[challengeOffset] = currentState
    }
}

extension ChallengeListCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.initialLineView.isHidden = scrollView.contentOffset.y > 4.0
    }
}
