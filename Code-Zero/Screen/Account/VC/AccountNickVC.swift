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
        UserDefaultManager.shared.removeAccessToken()
        changeRootViewToHome()
    }
    @IBAction func deleteAccountButton(_ sender: UIButton) {
        guard let popUpVC = storyboard?.instantiateViewController(identifier: "AccountDeleteVC")
                as? AccountDeleteVC else { return }
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
    }

    // MARK: - Property
    var originNickname: String? {
        didSet {
            guard let nick = originNickname else { return }
            deliveryChangeNickname(nick: nick)
        }
    }
    var changeNickClosure: ((String) -> Void)?

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
        if let nickname = originNickname {
            nickTextField.text = nickname
        } else {
            nickTextField.text = "워시유어보틀"
        }
        editButton.tag = 0
        duplicateCheckLabel.text = ""
        nickTextField.delegate = self
        nickTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    private func checkNickname() {
        guard editButton.tag == 1 else {
            nickTextField.becomeFirstResponder()
            return
        }
        guard let nickname = nickTextField.text else { return }
        if nickname.count == 0 {
            self.view.endEditing(true)
            changeButtonImage(editComplete: true)
            nickTextField.text = originNickname
        } else if nickname == originNickname {
            view.endEditing(true)
            changeButtonImage(editComplete: true)
        } else if nickname.count > 0 && nickname.count <= 5, let token = accessToken {
            requestUserNick(token: token, nick: nickname)
        }
    }
    private func deliveryChangeNickname(nick: String) {
        guard let changeNickClosure = changeNickClosure else { return }
        changeNickClosure(nick)
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
    private func changeButtonImage(editComplete: Bool) {
        switch editComplete {
        case true:
            editButton.setImage(UIImage(named: "icEditOrange"), for: .normal)
            editButton.tag = 0
        case false:
            editButton.setImage(UIImage(named: "icCheckOrange"), for: .normal)
            editButton.tag = 1
        }
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
                    self?.originNickname = nick
                    self?.changeButtonImage(editComplete: true)
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
        changeButtonImage(editComplete: false)
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
