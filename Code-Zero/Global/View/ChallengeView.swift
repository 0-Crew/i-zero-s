//
//  ChallengeView.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/20.
//

import UIKit

protocol ChallengeViewDelegate: AnyObject {
    func didEditButtonTap(challengeOffset: Int, yPosition: CGFloat)
    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState)
    func didChallengeTextFieldEdit(challengeOffset: Int, text: String)
}

extension ChallengeViewDelegate {
    func didEditButtonTap(challengeOffset: Int, yPosition: CGFloat) {
        return
    }
    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState) {
        return
    }
    func didChallengeTextFieldEdit(challengeOffset: Int, text: String) {
        return
    }
}

enum ChallengeState {
    case onboardingNotCompleted
    case onboardingCompleted
    case onboardingTodayNotCompleted
    case onboardingTodayCompleted
    case willChallenge
    case challengingNotCompleted
    case challengingCompleted
    case didChallengeNotCompleted
    case didChallengeCompleted
}

extension ChallengeState {

    var highlightViewIsHidden: Bool {
        switch self {
        case .willChallenge,
                .didChallengeNotCompleted,
                .didChallengeCompleted,
                .onboardingNotCompleted,
                .onboardingCompleted:
            return true
        case .challengingNotCompleted,
                .challengingCompleted,
                .onboardingTodayNotCompleted,
                .onboardingTodayCompleted:
            return false
        }
    }
    var highlightViewBackgroundColor: UIColor? {
        switch self {
        case .willChallenge,
                .challengingNotCompleted,
                .didChallengeNotCompleted,
                .didChallengeCompleted,
                .onboardingNotCompleted,
                .onboardingCompleted,
                .onboardingTodayNotCompleted,
                .onboardingTodayCompleted:
            return nil
        case .challengingCompleted:
            return .orangeMain
        }
    }

    var highlightViewBorderColor: UIColor? {
        switch self {
        case .willChallenge,
                .didChallengeNotCompleted,
                .didChallengeCompleted,
                .onboardingNotCompleted,
                .onboardingCompleted:
            return nil
        case .onboardingTodayNotCompleted, .onboardingTodayCompleted:
            return .gray1
        case .challengingNotCompleted, .challengingCompleted:
            return .orangeMain
        }
    }

    var dropWaterImage: UIImage? {
        switch self {
        case .willChallenge:
            return UIImage(named: "icWaterNone")
        case .challengingNotCompleted,
                .didChallengeNotCompleted,
                .onboardingNotCompleted,
                .onboardingTodayNotCompleted:
            return UIImage(named: "icWaterToday")
        case .challengingCompleted, .didChallengeCompleted, .onboardingCompleted, .onboardingTodayCompleted:
            return UIImage(named: "icWaterSuccess")
        }
    }

    var dateLabelIsHidden: Bool {
        switch self {
        case .willChallenge,
                .challengingNotCompleted,
                .didChallengeNotCompleted,
                .onboardingNotCompleted,
                .onboardingTodayNotCompleted:
            return false
        case .challengingCompleted, .didChallengeCompleted, .onboardingCompleted, .onboardingTodayCompleted:
            return true
        }
    }

    var dateLabelTextColor: UIColor? {
        switch self {
        case .willChallenge, .didChallengeNotCompleted, .onboardingNotCompleted:
            return .gray3
        case .challengingNotCompleted, .onboardingTodayNotCompleted:
            return .orangeMain
        case .challengingCompleted, .didChallengeCompleted, .onboardingCompleted, .onboardingTodayCompleted:
            return nil
        }
    }

    var challengeTextFieldTextColor: UIColor? {
        switch self {
        case .willChallenge,
                .onboardingNotCompleted,
                .onboardingCompleted,
                .onboardingTodayNotCompleted,
                .onboardingTodayCompleted:
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
        case .willChallenge,
                .challengingCompleted,
                .didChallengeCompleted,
                .onboardingNotCompleted,
                .onboardingCompleted,
                .onboardingTodayNotCompleted,
                .onboardingTodayCompleted:
            return true
        case .challengingNotCompleted, .didChallengeNotCompleted:
            return false
        }
    }

    var editButtonTintColor: UIColor? {
        switch self {
        case .willChallenge,
                .didChallengeCompleted,
                .onboardingNotCompleted,
                .onboardingCompleted,
                .onboardingTodayNotCompleted,
                .onboardingTodayCompleted:
            return nil
        case .challengingNotCompleted, .didChallengeNotCompleted:
            return .gray1
        case .challengingCompleted:
            return .white
        }
    }
}

class ChallengeView: UIView {
    // MARK: - IBOutlet
    @IBOutlet weak var highlightingView: UIView!
    @IBOutlet weak var dropWaterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var challengeTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!

    // MARK: - Property
    // MARK: Data Property
    internal var challengeOffset: Int!
    internal var challengeState: ChallengeState = .willChallenge
    internal var isMine: Bool!

    // MARK: Event Property
    internal weak var delegate: ChallengeViewDelegate?
    private var cachedChallengeText: String?
    private var toggleChallengeStateHandler: (() -> Void)?

    // MARK: - Lifecycle Method
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

    @objc private func didToggleChallengeStateTap() {
        toggleChallengeStateHandler?()
    }

    private func completeChallengeHandler() {
        setChallengeStateComplete()
        delegate?.didToggleChallengeStateAction(
            challengeOffset: challengeOffset,
            currentState: challengeState
        )
    }

    private func nonCompleteChallengeHandler() {
        setChallengeStateNonComplete()
        delegate?.didToggleChallengeStateAction(
            challengeOffset: challengeOffset,
            currentState: challengeState
        )
    }
    // MARK: - IBAction Method
    @IBAction func editButtonDidTap(sender: UIButton) {
        if challengeTextField.isEditing {
            challengeTextField.isEnabled = false
            challengeTextField.endEditing(false)
            delegate?.didEditButtonTap(challengeOffset: challengeOffset, yPosition: frame.minY)
            return
        }
        delegate?.didEditButtonTap(challengeOffset: challengeOffset, yPosition: frame.minY)
    }
    @IBAction func challengeTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            editButton.setImage(UIImage(named: "icXBlack"), for: .normal)
            return
        }

        editButton.setImage(UIImage(named: "icCheckBlack"), for: .normal)
    }
}

// MARK: - UI Setting
extension ChallengeView {
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
        // highlightView
        highlightingView.isHidden = state.highlightViewIsHidden
        highlightingView.backgroundColor = state.highlightViewBackgroundColor
        // dropWaterImageView
        dropWaterImageView.image = state.dropWaterImage
        // dateLabel
        dateLabel.isHidden = state.dateLabelIsHidden
        dateLabel.textColor = state.dateLabelTextColor
        // challengeTextField
        challengeTextField.textColor = state.challengeTextFieldTextColor
        // editButton
        editButton.isHidden = isMine ? state.editButtonIsHidden : true
        editButton.tintColor = state.editButtonTintColor
        editButton.setImage(UIImage(named: "icEdit"), for: .normal)
        highlightingView.setBorder(borderColor: state.highlightViewBorderColor, borderWidth: 1.0)

        switch state {
        case .willChallenge:
            toggleChallengeStateHandler = nil
        case .challengingNotCompleted,
                .didChallengeNotCompleted,
                .onboardingNotCompleted,
                .onboardingTodayNotCompleted:
            toggleChallengeStateHandler = isMine ? completeChallengeHandler : nil
        case .challengingCompleted, .didChallengeCompleted, .onboardingCompleted, .onboardingTodayCompleted:
            toggleChallengeStateHandler = isMine ? nonCompleteChallengeHandler : nil
        }
    }
    internal func setChallengeDate(date: Date?) {
        guard let date = date else { return }
        dateLabel.text = date.datePickerToString(format: "dd")
    }
    internal func setChallengeText(text: String) {
        challengeTextField.text = text
        cachedChallengeText = text
    }
    internal func toggleIsChangingState(to isChanging: Bool) {
        if isChanging {
            let isChallenging = challengeState == .challengingCompleted ||
            challengeState == .challengingNotCompleted
            let highlightViewColor: UIColor = isChallenging ? .orangeMain : .gray4
            let editButtonTintColor: UIColor = isChallenging ? .orangeMain : .gray4

            toggleChallengeStateHandler = nil

            highlightingView.isHidden = false
            highlightingView.setBorder(borderColor: highlightViewColor, borderWidth: 1.0)

            editButton.tintColor = editButtonTintColor
            editButton.setImage(UIImage(named: "icXBlack"), for: .normal)
        } else {
            setChallengeState(state: challengeState, isMine: true)
        }
    }
    internal func toggleTextEditingState(to isEditing: Bool) {
        if isEditing {
            challengeTextField.isEnabled = true
            challengeTextField.text = ""
            challengeTextField.becomeFirstResponder()
            toggleChallengeStateHandler = nil
        } else {
            challengeTextField.text = cachedChallengeText
            setChallengeState(state: challengeState, isMine: true)
        }
    }
    private func setChallengeStateComplete() {
        switch challengeState {
        case .challengingNotCompleted:
            setChallengeState(state: .challengingCompleted, isMine: isMine)
        case .didChallengeNotCompleted:
            setChallengeState(state: .didChallengeCompleted, isMine: isMine)
        case .onboardingNotCompleted:
            setChallengeState(state: .onboardingCompleted, isMine: true)
        case .onboardingTodayNotCompleted:
            setChallengeState(state: .onboardingTodayCompleted, isMine: true)
        default:
            break
        }
    }
    private func setChallengeStateNonComplete() {
        switch challengeState {
        case .challengingCompleted:
            setChallengeState(state: .challengingNotCompleted, isMine: isMine)
        case .didChallengeCompleted:
            setChallengeState(state: .didChallengeNotCompleted, isMine: isMine)
        case .onboardingCompleted:
            setChallengeState(state: .onboardingNotCompleted, isMine: true)
        case .onboardingTodayCompleted:
            setChallengeState(state: .onboardingTodayNotCompleted, isMine: true)
        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate
extension ChallengeView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.count != 0 else {
            toggleTextEditingState(to: false)
            return
        }
        delegate?.didChallengeTextFieldEdit(challengeOffset: challengeOffset, text: text)
    }
}
