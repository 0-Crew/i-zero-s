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

    // MARK: - @IBAction
    @IBAction func nextButtonDidTap(_ sender: UIButton) {
        if nickTextField.text != "" {
            if let text = nickTextField.text {
                print(checkDuplicateNick(nick: text))
            }
        }
    }
    // MARK: - Property
    var duplicateNick: [String] = ["민희", "주혁", "보틀월드"]
    lazy var accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50.0))
    }()
    var nextButton: UIButton = {
        let button = UIButton()
        button.setButton(text: "확인",
                         color: .gray3,
                         font: .spoqaHanSansNeo(size: 16, family: .bold),
                         backgroundColor: .red)
        button.backgroundColor = .gray2
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
        duplicateCheckLabel.isHidden = true
        nickTextField.delegate = self
        nickTextField.inputAccessoryView = accessoryView
        accessoryView.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        nickTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    func checkDuplicateNick(nick: String) -> Bool {  // 중복검사(서버로 대체 예정)
        return duplicateNick.contains(nick)
    }
    func filterNickName(text: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: "[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9!_]")
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
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces) // 스페이스 제거
        if let text = textField.text {
            if let regexText = filterNickName(text: text) {
                textField.text = regexText
            }
        }

        if let count = textField.text?.count {
            if count > 0 && count < 6 {
                nextButton.backgroundColor = .orangeMain
                nextButton.setTitleColor(.white, for: .normal)
                nextButton.isEnabled = true
            } else {
                nextButton.backgroundColor = .gray2
                nextButton.setTitleColor(.gray3, for: .normal)
                nextButton.isEnabled = false
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
