//
//  ChallengeView.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/20.
//

import UIKit

protocol ChallengeViewDelegate: AnyObject {
    func didEditButtonTap(challengeOffset: Int)
    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState)
}

enum ChallengeState {
    case willChallenge
    case challengingNotCompleted
    case challengingCompleted
    case didChallengeNotCompleted
    case didChallengeCompleted
}

class ChallengeView: UIView {
    @IBOutlet weak var highlightingView: UIView!
    @IBOutlet weak var dropWaterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var challengeTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!

    internal var challengeOffset: Int!
    internal var challengeState: ChallengeState = .willChallenge
    internal var isMine: Bool!
    internal weak var delegate: ChallengeViewDelegate!
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var toggleChallengeStateHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        initView()
    }

    private func loadView() {
        let nibs = Bundle.main.loadNibNamed("ChallengeView", owner: self, options: nil)

        guard let xibView = nibs?.first as? UIView else { return }
        xibView.frame = self.bounds
        addSubview(xibView)
        xibView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func initView() {
        backgroundColor = .clear
        highlightingView.setBorder(borderColor: .orangeMain, borderWidth: 1.0)

        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didToggleChallengeStateTap))
        dropWaterImageView.isUserInteractionEnabled = true
        dropWaterImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    // swiftlint:disable function_body_length
    internal func setChallengeState(state: ChallengeState, isMine: Bool) {
        challengeState = state
        self.isMine = isMine
        switch state {
        case .willChallenge:
            highlightingView.isHidden = true

            dropWaterImageView.image = UIImage(named: "icWaterNone")
            toggleChallengeStateHandler = nil

            dateLabel.isHidden = false
            dateLabel.textColor = .gray3

            challengeTextField.textColor = .gray2

            editButton.isHidden = true
        case .challengingNotCompleted:
            highlightingView.isHidden = false
            highlightingView.backgroundColor = .clear

            dropWaterImageView.image = UIImage(named: "icWaterToday")
            toggleChallengeStateHandler = completeChallengeHandlerProvider

            dateLabel.isHidden = false
            dateLabel.textColor = .orangeMain

            challengeTextField.textColor = .orangeMain

            editButton.isHidden = isMine ? false : true
            editButton.tintColor = .gray1
        case .challengingCompleted:
            highlightingView.isHidden = false
            highlightingView.backgroundColor = .orangeMain

            dropWaterImageView.image = UIImage(named: "icWaterSuccess")
            toggleChallengeStateHandler = isMine ? nonCompleteChallengeHandlerProvider : nil

            dateLabel.isHidden = true

            challengeTextField.textColor = .white

            editButton.isHidden = isMine ? false : true
            editButton.tintColor = .white
        case .didChallengeNotCompleted:
            highlightingView.isHidden = true

            dropWaterImageView.image = UIImage(named: "icWaterToday")
            toggleChallengeStateHandler = isMine ? completeChallengeHandlerProvider : nil

            dateLabel.isHidden = false
            dateLabel.textColor = .gray1

            challengeTextField.textColor = .gray4

            editButton.isHidden = isMine ? false : true
            editButton.tintColor = .gray1
        case .didChallengeCompleted:
            highlightingView.isHidden = true

            dropWaterImageView.image = UIImage(named: "icWaterSuccess")
            toggleChallengeStateHandler = isMine ? nonCompleteChallengeHandlerProvider : nil

            dateLabel.isHidden = true

            challengeTextField.textColor = .gray4

            editButton.isHidden = true
            editButton.tintColor = .gray1
        }
    }
    // swiftlint:enable function_body_length

    @objc func didToggleChallengeStateTap() {
        toggleChallengeStateHandler?()
    }

    private func completeChallengeHandlerProvider() {
        setChallengeStateComplete()
        delegate.didToggleChallengeStateAction(
            challengeOffset: challengeOffset,
            currentState: challengeState
        )
    }

    private func nonCompleteChallengeHandlerProvider() {
        setChallengeStateNonComplete()
        delegate.didToggleChallengeStateAction(
            challengeOffset: challengeOffset,
            currentState: challengeState
        )
    }

    private func setChallengeStateComplete() {
        if challengeState == .challengingNotCompleted {
            setChallengeState(state: .challengingCompleted, isMine: isMine)
        } else if challengeState == .didChallengeNotCompleted {
            setChallengeState(state: .didChallengeCompleted, isMine: isMine)
        }
    }

    private func setChallengeStateNonComplete() {
        if challengeState == .challengingCompleted {
            setChallengeState(state: .challengingNotCompleted, isMine: isMine)
        } else if challengeState == .didChallengeCompleted {
            setChallengeState(state: .didChallengeNotCompleted, isMine: isMine)
        }
    }

    @IBAction func editButtonDidTap(sender: UIButton) {
        delegate?.didEditButtonTap(challengeOffset: challengeOffset)
    }
}
