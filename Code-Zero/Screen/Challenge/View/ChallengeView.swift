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

extension ChallengeState {

    var highlightViewIsHidden: Bool {
        switch self {
        case .willChallenge, .didChallengeNotCompleted, .didChallengeCompleted:
            return true
        case .challengingNotCompleted, .challengingCompleted:
            return false
        }
    }
    var highlightViewBackgroundColor: UIColor? {
        switch self {
        case .willChallenge, .challengingNotCompleted, .didChallengeNotCompleted, .didChallengeCompleted:
            return nil
        case .challengingCompleted:
            return .orangeMain
        }
    }

    var dropWaterImage: UIImage? {
        switch self {
        case .willChallenge:
            return UIImage(named: "icWaterNone")
        case .challengingNotCompleted, .didChallengeNotCompleted:
            return UIImage(named: "icWaterToday")
        case .challengingCompleted, .didChallengeCompleted:
            return UIImage(named: "icWaterSuccess")
        }
    }

    var dateLabelIsHidden: Bool {
        switch self {
        case .willChallenge, .challengingNotCompleted, .didChallengeNotCompleted:
            return false
        case .challengingCompleted, .didChallengeCompleted:
            return true
        }
    }

    var dateLabelTextColor: UIColor? {
        switch self {
        case .willChallenge, .didChallengeNotCompleted:
            return .gray3
        case .challengingNotCompleted:
            return .orangeMain
        case .challengingCompleted, .didChallengeCompleted:
            return nil
        }
    }

    var challengeTextFieldTextColor: UIColor? {
        switch self {
        case .willChallenge:
            return .gray2
        case .challengingNotCompleted:
            return .orangeMain
        case .challengingCompleted:
            return .white
        case .didChallengeNotCompleted, .didChallengeCompleted:
            return .gray4
        }
    }

    var editButtonIsHidden: Bool {
        switch self {
        case .willChallenge, .challengingCompleted, .didChallengeCompleted:
            return true
        case .challengingNotCompleted, .didChallengeNotCompleted:
            return false
        }
    }

    var editButtonTintColor: UIColor? {
        switch self {
        case .willChallenge, .didChallengeCompleted:
            return nil
        case .challengingNotCompleted, .didChallengeNotCompleted:
            return .gray1
        case .challengingCompleted:
            return .white
        }
    }
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

    internal func setChallengeState(state: ChallengeState, isMine: Bool) {
        challengeState = state
        self.isMine = isMine

        highlightingView.isHidden = state.highlightViewIsHidden
        highlightingView.backgroundColor = state.highlightViewBackgroundColor

        dropWaterImageView.image = state.dropWaterImage

        dateLabel.isHidden = state.dateLabelIsHidden
        dateLabel.textColor = state.dateLabelTextColor

        challengeTextField.textColor = state.challengeTextFieldTextColor

        editButton.isHidden = isMine ? state.editButtonIsHidden : true
        editButton.tintColor = state.editButtonTintColor

        switch state {
        case .willChallenge:
            toggleChallengeStateHandler = nil
        case .challengingNotCompleted, .didChallengeNotCompleted:
            toggleChallengeStateHandler = isMine ? completeChallengeHandlerProvider : nil
        case .challengingCompleted, .didChallengeCompleted:
            toggleChallengeStateHandler = isMine ? nonCompleteChallengeHandlerProvider : nil
        }
    }

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
