//
//  EmptyChallengeView.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/05/30.
//

import UIKit

protocol EmptyChallengeViewDelegate: AnyObject {
    func didStartChallengeViewTap()
    func didPresentCalendarViewDidTap()
}

class EmptyChallengeView: LoadXibView {

    @IBOutlet weak var startChallengeView: UIView!
    @IBOutlet weak var presentCalendarView: UIView!

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

    private func initView() {
        presentCalendarView.setBorder(borderColor: .orangeMain, borderWidth: 1.0)
        registRecognizer()
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
