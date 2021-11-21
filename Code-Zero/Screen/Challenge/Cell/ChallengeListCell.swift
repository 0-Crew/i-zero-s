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
    @IBOutlet weak var initialLineView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var challengeListStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }

    // MARK: - Property
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
            challengView?.editButton.tag = $0.offset
        }
    }

    @IBAction func calendarButtonDidTap(sender: UIButton) {
        delegate?.didCalendarButtonTap()
    }
}

extension ChallengeListCell: ChallengeViewDelegate {
    func didEditButtonTap(buttonTag: Int) {

    }
}

extension ChallengeListCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.initialLineView.isHidden = scrollView.contentOffset.y > 4.0
    }
}
