//
//  ChallengeOpenSecondStepView.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/04.
//

import UIKit

class ChallengeOpenSecondStepView: LoadXibView, ChallengeOpenStepViewType {
    // MARK: - IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var inconvenientInputTextField: UITextField!
    @IBOutlet weak var optionTableView: UITableView!
    // MARK: - Property
    internal var optionList: [String] = (0...5).map { "선택지\($0)"} + ["직접입력"]
    internal var selectedInconvenientText: String = "" {
        didSet {
            let canPass = selectedInconvenientText.count != 0
            inconvenientInputTextField.text = selectedInconvenientText
            delegate?.challengeStep(step: .second, inputString: selectedInconvenientText)
            delegate?.challengeStepCanPass(step: .second, canPass: canPass)
        }
    }
    internal weak var delegate: ChallengeOpenStepDelegate?

    // MARK: - Lifecycle Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    // MARK: - IBAction
    @IBAction func inconvenientInputTextFieldEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            containerView.setBorder(borderColor: .gray2, borderWidth: 1)
            return
        }
        text.count == 0 ?
        containerView.setBorder(borderColor: .gray2, borderWidth: 1) :
        containerView.setBorder(borderColor: .orangeMain, borderWidth: 1)
        selectedInconvenientText = text
    }
}

// MARK: - UI Setting
extension ChallengeOpenSecondStepView {
    private func initView() {
        containerView.setBorder(borderColor: .orangeMain, borderWidth: 1)
        inconvenientInputTextField.text = optionList[0]
        inconvenientInputTextField.delegate = self
        optionTableView.registerCell(cellType: OptionCell.self)
        optionTableView.setBorder(borderColor: .orangeMain, borderWidth: 1)
        optionTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
}
// MARK: - UITextFieldDelegate
extension ChallengeOpenSecondStepView: UITextFieldDelegate {
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
// MARK: - UITableViewDelegate
extension ChallengeOpenSecondStepView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == optionList.count - 1 {
            inconvenientInputTextField.text = ""
            selectedInconvenientText = ""
            containerView.setBorder(borderColor: .gray2, borderWidth: 1)
            inconvenientInputTextField.isEnabled = true
            inconvenientInputTextField.becomeFirstResponder()
            return
        }
        containerView.setBorder(borderColor: .orangeMain, borderWidth: 1)
        inconvenientInputTextField.isEnabled = false
        inconvenientInputTextField.endEditing(false)
        selectedInconvenientText = optionList[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension ChallengeOpenSecondStepView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OptionCell = tableView.dequeueCell(indexPath: indexPath)
        cell.setCellType(type: .challengeOpen)
        cell.optionTextLabel.text = optionList[indexPath.row]
        return cell
    }
}

// MARK: - ChallengeOpenStepViewType
extension ChallengeOpenSecondStepView {
    func presentStep(userInput: UserInputTextTuple?) {
        let canPass: Bool = inconvenientInputTextField.text?.count != 0 ? true: false
        delegate?.challengeStepCanPass(step: .first, canPass: canPass)
    }
}
