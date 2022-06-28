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
        guard let text = nickTextField.text, let token = accessToken else { return }
        requestUserNick(token: token, nick: text)
    }

    func moveChallengeVC() {
        let storybard = UIStoryboard(name: "Challenge", bundle: nil)
        let challengeVC = storybard.instantiateViewController(withIdentifier: "Challenge")
        UIApplication.shared.windows.first?.replaceRootViewController(
            challengeVC,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - Network Function
extension NickSettingVC {
    private func requestUserNick(token: String, nick: String) {
        UserSettingService.shared.changeUserNick(nick: nick,
                                                 token: token) { [weak self] result in
            switch result {
            case .success(let response):
                if response.message == "유저 이름 세팅 성공" {
                    self?.moveChallengeVC()
                }
            case .requestErr(let error):
                if error == "duplicateNick" {
                    self?.duplicateCheckLabel.isHidden = false
                    self?.duplicateCheckLabel.text = "이미 사용 중이에요! 다른 닉네임을 적어주세요"
                }
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("serverErr")
            }
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
        if let count = textField.text?.count {
            if count > 0 && count < 6 {
                checkDuplicateNick()
                return true
            }
        }
        return false
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
