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

    }
    @IBAction func deleteAccountButton(_ sender: UIButton) {

    }

    // MARK: - Property
    var email: String = "xwoud@naver.com"
    var nick: String = "희영룰루루"

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nickView.setBorder(borderColor: .gray2, borderWidth: 1)
        emailLabel.text = email
        nickTextField.text = nick
        duplicateCheckLabel.text = ""
        nickTextField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkNickname()
    }
}

extension AccountNickVC {
    func checkNickname() {
        guard let nickCount = nickTextField.text?.count else { return }
        if nickCount == 0 {
            self.view.endEditing(true)
            editButton.setImage(UIImage(named: "icEditOrange"), for: .normal)
            nickTextField.text = nick
        }
        if nickCount > 0 && nickCount <= 5 {
            // 중복검사
        }

    }
}

extension AccountNickVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editButton.setImage(UIImage(named: "icCheckOrange"), for: .normal)
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
