//
//  NickSettingVC.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/19.
//

import UIKit
import SnapKit

class NickSettingVC: UIViewController {

    // MARK: - @IBOutlet
    @IBOutlet weak var nickBoxView: UIView!
    @IBOutlet weak var nickTextField: UITextField!
    @IBOutlet weak var duplicateCheckLabel: UILabel!

    // MARK: - Property
    var duplicateNick: [String] = ["민희", "주혁", "보틀월드"]
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0,
                                    y: 0.0,
                                    width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.width * 50 / 375))
    }()
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setButton(text: "확인",
                         color: .gray3,
                         font: .spoqaHanSansNeo(size: 16, family: .bold),
                         backgroundColor: .red)
        button.backgroundColor = .gray2
        button.addTarget(self, action: #selector(checkDuplicateNick), for: .touchUpInside)
        return button
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
}

// MARK: - View Layout Style
extension NickSettingVC {
    func setView() {
        nickTextField.becomeFirstResponder()
        nickBoxView.setBorder(borderColor: .gray2, borderWidth: 1)
        duplicateCheckLabel.text = ""
        nickTextField.delegate = self
        nickTextField.inputAccessoryView = accessoryView
        accessoryView.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        nickTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func checkDuplicateNick() {
        guard let text = nickTextField.text else { return }
        guard duplicateNick.contains(text) else {
            // 설정 페이지로 이동
            return
        }
        duplicateCheckLabel.isHidden = false
        duplicateCheckLabel.text = "이미 사용 중이에요! 다른 닉네임을 적어주세요"
    }

    func filterNickName(text: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: "[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9_]")
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }.joined(separator: "")

        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - UITextFieldDelegate
extension NickSettingVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {

        if let count = textField.text?.count {
            if count > 0 && count < 6 {
                nextButton.backgroundColor = .orangeMain
                nextButton.setTitleColor(.white, for: .normal)
                nextButton.isEnabled = true
                duplicateCheckLabel.text = ""
            } else {
                nextButton.backgroundColor = .gray2
                nextButton.setTitleColor(.gray3, for: .normal)
                nextButton.isEnabled = false
                duplicateCheckLabel.text = count == 0 ? "" : "5글자까지만 입력할 수 있어요!"
            }
        }

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if string.isEmpty {
            return true
        }
        switch string {
        case "ㄱ"..."ㅎ", "a"..."z", "A"..."Z", "ㅏ"..."ㅣ", "0"..."9", "_":
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            return updatedText.count <= 7
        default:
            return false
        }
    }
}
