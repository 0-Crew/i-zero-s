//
//  AccountNickVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/06.
//

import UIKit

class AccountNickVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var nickView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var duplicateCheckLabel: UILabel!

    // MARK: - @IBAction
    @IBAction func editButtonDidTap(_ sender: UIButton) {
        checkNickname()
    }
    @IBAction func logoutButtonDidTap(_ sender: UIButton) {
        // TODO: 로그아웃(토큰 삭제?)
        changeRootViewToHome()
    }
    @IBAction func deleteAccountButton(_ sender: UIButton) {
        // TODO: 알랏창으로 이동
        guard let popUpVC =
                storyboard?.instantiateViewController(identifier: "AccountDeleteVC") as? AccountDeleteVC else {return}
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
    }

    // MARK: - Property
    var email: String = "xwoud@naver.com"
    var nick: String = "희영룰루루"
    var duplicateNick: [String] = ["민희", "주혁", "보틀월드"]

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkNickname()
    }
}

// MARK: - Set View Layout && Function
extension AccountNickVC {
    private func setLayout() {
        nickView.setBorder(borderColor: .gray2, borderWidth: 1)
        emailLabel.text = email
        nickTextField.text = nick
        duplicateCheckLabel.text = ""
        nickTextField.delegate = self
    }
    private func checkNickname() {
        guard let nickCount = nickTextField.text?.count else { return }
        if nickCount == 0 {
            self.view.endEditing(true)
            editButton.setImage(UIImage(named: "icEditOrange"), for: .normal)
            nickTextField.text = nick
        }
        if nickCount > 0 && nickCount <= 5 {
            guard let text = nickTextField.text else { return }
            guard duplicateNick.contains(text) else {
                self.view.endEditing(true)
                // TODO: 서버에 닉네임 저장해야함
                nick =  nickTextField.text!
                editButton.setImage(UIImage(named: "icEditOrange"), for: .normal)
                return
            }
            duplicateCheckLabel.text = "이미 사용 중이에요! 다른 닉네임을 적어주세요"
        }
    }
    private func changeRootViewToHome() {
        let storybard = UIStoryboard(name: "Home", bundle: nil)
        let homeNavigationVC = storybard.instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.replaceRootViewController(
            homeNavigationVC,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UITextFieldDelegate
extension AccountNickVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editButton.setImage(UIImage(named: "icCheckOrange"), for: .normal)
    }
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b") // 백스페이스 감지
            if isBackSpace == -92 {
                duplicateCheckLabel.text = textField.text?.count ?? 0 > 6 ? "5자까지만 입력할 수 있어요" : ""
            }
        }

        if string.isEmpty {
            return true
        }
        switch string {
        case "ㄱ"..."ㅎ", "a"..."z", "A"..."Z", "ㅏ"..."ㅣ", "0"..."9", "_":
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            duplicateCheckLabel.text = updatedText.count > 5 ? "5자까지만 입력할 수 있어요!" : ""
            return updatedText.count <= 7
        default:
            return false
        }
    }
}
