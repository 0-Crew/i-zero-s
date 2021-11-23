//
//  EmptyCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/23.
//

import UIKit

import SnapKit

protocol EmptyChallengeCellDelegate: AnyObject {
    func didStartChallengeViewTap()
}

class EmptyChallengeCell: UICollectionViewCell {

    private var emptyDescriptionLabelTopConstraints: Constraint?
    internal weak var delegate: EmptyChallengeCellDelegate?

    @IBOutlet weak var emptyImageView: UIView!
    @IBOutlet weak var emptyDescriptionLabel: UILabel!
    @IBOutlet weak var startChallengeView: UIView!

    override func awakeFromNib() {
        startChallengeView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(startChallengeViewDidTap))
        startChallengeView.addGestureRecognizer(tapGesture)

        emptyDescriptionLabel.snp.makeConstraints {
            emptyDescriptionLabelTopConstraints = $0.top.equalTo(emptyImageView.snp.bottom)
                .offset(12).constraint
            $0.centerX.equalToSuperview()
        }
        startChallengeView.snp.makeConstraints {
            $0.top.equalTo(emptyDescriptionLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }

    internal func setEmptyChallengeView(isMine: Bool) {
        if isMine {
            startChallengeView.isHidden = false

            emptyDescriptionLabel.text = "현재 진행 중인 챌린지가 없어요\n보틀을 씻고 새 챌린지를 시작해보세요!"
            emptyDescriptionLabel.font = .spoqaHanSansNeo(size: 13, family: .medium)
            emptyDescriptionLabel.textColor = .gray2
            emptyDescriptionLabelTopConstraints?.update(offset: 12)

        } else {
            startChallengeView.isHidden = true
            emptyDescriptionLabel.text = "새로운 챌린지를 기다리는 중…"
            emptyDescriptionLabel.font = .spoqaHanSansNeo(size: 16, family: .bold)
            emptyDescriptionLabelTopConstraints?.update(offset: 30)
        }
    }

    @objc func startChallengeViewDidTap() {
        delegate?.didStartChallengeViewTap()
    }
}
