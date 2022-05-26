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
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func editButtonDidTap(_ sender: UIButton) {
        checkNickname()
    }
    @IBAction func logoutButtonDidTap(_ sender: UIButton) {
        // TODO: 로그아웃(토큰 삭제?)
        changeRootViewToHome()
    }
    @IBAction func deleteAccountButton(_ sender: UIButton) {
        guard let popUpVC =
                storyboard?.instantiateViewController(identifier: "AccountDeleteVC") as? AccountDeleteVC else {return}
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
    }

    // MARK: - Property
    var email: String?
    var nickname: String?

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
        if let email = email,
           let nickname = nickname {
            emailLabel.text = email
            nickTextField.text = nickname
        } else {
            emailLabel.text = "wash@your.bottle"
            nickTextField.text = "워시유어보틀"
        }
        duplicateCheckLabel.text = ""
        nickTextField.delegate = self
        nickTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    private func checkNickname() {
        guard let nickname = nickTextField.text else { return }
        if nickname.count == 0 {
            self.view.endEditing(true)
            editButton.setImage(UIImage(named: "icEditOrange"), for: .normal)
            nickTextField.text = nickname
        }
        if nickname.count > 0 && nickname.count <= 5 {
            // swiftlint:disable line_length
            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTgsImVtYWlsIjoieHdvdWRAdGVzdC5jb20iLCJuYW1lIjoibWluaTMiLCJpZEZpcmViYXNlIjoidzZtblY4VklVU1hWY080Q0paVkNPTHowS2F1MiIsImlhdCI6MTY0NTM3NTM4MCwiZXhwIjoxNjQ3OTY3MzgwLCJpc3MiOiJXWUIifQ.JYS2amG9ydX_BeDCYDc93_cWDGhGOQ29Nq2CGW4SpZE"
             // swiftlint:enable line_length
            requestUserNick(token: token, nick: nickname)
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
// MARK: - Network
extension AccountNickVC {
    private func requestUserNick(token: String, nick: String) {
        UserSettingService.shared.changeUserNick(nick: nick,
                                                 token: token) { [weak self] result in
            switch result {
            case .success(let response):
                if response.message == "유저 이름 세팅 성공" {
                    self?.view.endEditing(true)
                    self?.nickname = nick
                    self?.editButton.setImage(UIImage(named: "icEditOrange"), for: .normal)
                }
            case .requestErr(let error):
                if error == "duplicateNick" {
                    self?.duplicateCheckLabel.text = "이미 사용 중이에요! 다른 닉네임을 적어주세요"
                }
            case .serverErr:
                print("serverErr")
            case .networkFail:
                // TODO: 서버 점검중
                print("serverErr")
            }
        }
    }
}
// MARK: - UITextFieldDelegate
extension AccountNickVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editButton.setImage(UIImage(named: "icCheckOrange"), for: .normal)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {

        if let count = textField.text?.count {
            if count > 0 && count < 6 {
                duplicateCheckLabel.text = ""
            } else {
                duplicateCheckLabel.text = count == 0 ? "" : "5글자까지만 입력할 수 있어요!"
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editButtonDidTap(editButton)
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
