//
//  ChallengeOpenFirstStepView.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/04.
//

import UIKit

class ChallengeOpenFirstStepView: LoadXibView, ChallengeOpenStepViewType {

    // MARK: - IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var convenientInputTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!

    // MARK: - Property
    internal weak var delegate: ChallengeOpenStepDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        convenientInputTextField.endEditing(false)
    }

    // MARK: - IBAction
    @IBAction func convenientInputTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            unhighlightingContainerView()
            return
        }
        let canPass = text.count != 0
        canPass ? highlightingContainerView() : unhighlightingContainerView()
        delegate?.challengeStepCanPass(step: .first, canPass: canPass)
        delegate?.challengeStep(step: .first, inputString: text)
    }
    @IBAction func editButtonDidTap(sender: Any) {
        convenientInputTextField.becomeFirstResponder()
    }
}

// MARK: - UI Setting
extension ChallengeOpenFirstStepView {
    private func initView() {
        unhighlightingContainerView()
    }
    private func highlightingContainerView() {
        containerView.setBorder(borderColor: .orangeMain, borderWidth: 1)
        editButton.isHidden = true
    }
    private func unhighlightingContainerView() {
        containerView.setBorder(borderColor: .gray2, borderWidth: 1)
        editButton.isHidden = false
    }
    internal func setTextFieldPlaceHolder(examples: [Convenience]) {
        delegate?.challengeStepCanPass(step: .first, canPass: false)
        let randomConvenience = examples.randomElement()
        convenientInputTextField.placeholder = randomConvenience?.name
    }
}

// MARK: - UITextFieldDelegate
extension ChallengeOpenFirstStepView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        return true
    }
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else {
            return true
        }
        if text.count + string.count > 20 {
            return false
        }
        return true
    }
}

extension ChallengeOpenFirstStepView {
    func presentStep(userInput: UserInputTextTuple?) {
        let canPass: Bool = convenientInputTextField.text?.count != 0
        delegate?.challengeStepCanPass(step: .first, canPass: canPass)
    }
}
