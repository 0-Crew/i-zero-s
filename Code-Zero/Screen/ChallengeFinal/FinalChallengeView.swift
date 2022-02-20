//
//  FinalChallengeView.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/02/20.
//

import UIKit

enum FinalChallengeViewState {
    case challengeNotComplete
    case challengeWillEdit
    case challengeEditing
    case challengeComplete
}

extension FinalChallengeViewState {
    var dropWaterImage: UIImage? {
        switch self {
        case .challengeNotComplete, .challengeEditing, .challengeWillEdit:
            return UIImage(named: "icWaterToday")
        case .challengeComplete:
            return UIImage(named: "icWaterSuccess")
        }
    }
    var dateLabelIsHidden: Bool {
        switch self {
        case .challengeNotComplete, .challengeWillEdit, .challengeEditing:
            return false
        case .challengeComplete:
            return true
        }
    }
    var highlightViewIsHidden: Bool {
        switch self {
        case .challengeNotComplete, .challengeComplete:
            return true
        case .challengeWillEdit, .challengeEditing:
            return false
        }
    }
    var editButtonIsHidden: Bool {
        switch self {
        case .challengeNotComplete:
            return false
        case .challengeWillEdit, .challengeEditing, .challengeComplete:
            return true
        }
    }
    var editCompleteButtonImage: UIImage? {
        switch self {
        case .challengeNotComplete, .challengeComplete:
            return nil
        case .challengeWillEdit:
            return UIImage(named: "icXBlack")
        case .challengeEditing:
            return UIImage(named: "icCheckBlack")
        }
    }
    var editCompleteButtonTintColor: UIColor? {
        switch self {
        case .challengeNotComplete, .challengeComplete:
            return nil
        case .challengeWillEdit:
            return .gray4
        case .challengeEditing:
            return .orangeMain
        }
    }
    var challengeTextFieldIsEnable: Bool {
        switch self {
        case .challengeNotComplete, .challengeComplete:
            return false
        case .challengeWillEdit, .challengeEditing:
            return true
        }
    }
    var challengeTextFieldColor: UIColor {
        switch self {
        case .challengeNotComplete, .challengeWillEdit, .challengeEditing:
            return .gray2
        case .challengeComplete:
            return .orangeMain
        }
    }
}

protocol FinalChallengeViewDelegate: AnyObject {
    func challengeTextFieldWillEdit(offset: Int)
    func challengeTextFieldDidEdit(offset: Int, inputText: String?)
    func toggleChallengeStateDidTap(offset: Int, state: FinalChallengeViewState)
}

class FinalChallengeView: LoadXibView {

    @IBOutlet weak var dropWaterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var challengeTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editCompleteButton: UIButton!
    @IBOutlet weak var highlightView: UIView!

    var offset: Int!
    var state: FinalChallengeViewState!
    weak var delegate: FinalChallengeViewDelegate?
    var cachedText: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    @IBAction func editButtonDidTap() {
        setState(state: .challengeEditing)
        delegate?.challengeTextFieldWillEdit(offset: offset)
    }

    @IBAction func editCompleteButtonDidTap() {
        setState(state: .challengeNotComplete)
        if let text = challengeTextField.text,
           text.isEmpty {
            challengeTextField.text = cachedText
        }
        delegate?.challengeTextFieldDidEdit(offset: offset, inputText: challengeTextField.text)
    }

    @IBAction func tooggleChallengeStateDidTap() {
        switch state {
        case .challengeNotComplete:
            setState(state: .challengeComplete)
            delegate?.toggleChallengeStateDidTap(offset: offset, state: .challengeComplete)
        case .challengeComplete:
            setState(state: .challengeNotComplete)
            delegate?.toggleChallengeStateDidTap(offset: offset, state: .challengeNotComplete)
        default:
            break
        }
    }

    @IBAction func challengeTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            setState(state: .challengeWillEdit)
            return
        }
        setState(state: .challengeEditing)
    }

}

extension FinalChallengeView {
    private func initView() {
        highlightView.setBorder(borderColor: .orangeMain, borderWidth: 1)

        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(tooggleChallengeStateDidTap))
        dropWaterImageView.isUserInteractionEnabled = true
        dropWaterImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    func setState(state: FinalChallengeViewState) {
        self.state = state
        dropWaterImageView.image = state.dropWaterImage
        dateLabel.isHidden = state.dateLabelIsHidden
        challengeTextField.isEnabled = state.challengeTextFieldIsEnable
        challengeTextField.textColor = state.challengeTextFieldColor
        highlightView.isHidden = state.highlightViewIsHidden
        editCompleteButton.setImage(state.editCompleteButtonImage, for: .normal)
        editCompleteButton.tintColor = state.editCompleteButtonTintColor ?? .gray4
        editButton.isHidden = state.editButtonIsHidden
    }
}

extension FinalChallengeView: UITextFieldDelegate {

}
