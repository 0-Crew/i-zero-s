//
//  EmptyChallengeView.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/05/30.
//

import UIKit
import SnapKit

protocol EmptyChallengeViewDelegate: AnyObject {
    func didStartChallengeViewTap()
    func didPresentCalendarViewDidTap()
}

class EmptyChallengeView: LoadXibView {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startChallengeView: UIView!
    @IBOutlet weak var presentCalendarView: UIView!

    @IBOutlet weak var presentCalendarViewTopConstraint: NSLayoutConstraint!


    weak var delegate: EmptyChallengeViewDelegate?

    // MARK: - Lifecycle Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    convenience init(frame: CGRect, isMine: Bool) {
        self.init(frame: frame)
        initView()
        if !isMine {
            initOtherUserEmptyView()
        }

    }

    private func initView() {
        presentCalendarView.setBorder(borderColor: .orangeMain, borderWidth: 1.0)
        registRecognizer()
    }

    private func initOtherUserEmptyView() {
        descriptionLabel.text = "새로운 챌린지를 기다리는 중…"
        startChallengeView.isHidden = true
        NSLayoutConstraint.deactivate([presentCalendarViewTopConstraint])

        presentCalendarView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
        }

    }

    private func registRecognizer() {
        startChallengeView.isUserInteractionEnabled = true
        presentCalendarView.isUserInteractionEnabled = true

        let startChallengeViewTapGesture = UITapGestureRecognizer()
        startChallengeViewTapGesture.addTarget(self, action: #selector(startChallengeViewDidTap))
        startChallengeView.addGestureRecognizer(startChallengeViewTapGesture)

        let presentCalendarViewTapGesture = UITapGestureRecognizer()
        presentCalendarViewTapGesture.addTarget(self, action: #selector(presentCalendarViewDidTap))
        presentCalendarView.addGestureRecognizer(presentCalendarViewTapGesture)
    }

    @objc func startChallengeViewDidTap() {
        delegate?.didStartChallengeViewTap()
    }

    @objc func presentCalendarViewDidTap() {
        delegate?.didPresentCalendarViewDidTap()
    }

}
