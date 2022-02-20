//
//  SignInVC.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/19.
//

import UIKit

class SignInVC: UIViewController {

    // MARK: - @IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    // MARK: - @IBAction
    @IBAction func loginButtonDidTap(_ sender: Any) {
        requestLogin()

    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
}

// MARK: - View Layout Style
extension SignInVC {
    func setView() {
        backButton.setTitle("", for: .normal)
        titleLabel.setLineSpacing(lineSpacing: 12)
        titleLabel.textAlignment = .left
        subtitleLabel.setLineSpacing(lineSpacing: 5)
        subtitleLabel.textAlignment = .left
    }

    func requestLogin() {
        UserLoginService.shared.requestLogin(id: "mini1234",
                                             email: "xwoud@test.com",
                                             provider: "apple") { [weak self] result in
            switch result {

            case .success(let data):
                print(data)
            case .requestErr(let error):
                print(error)
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("serverErr")
            }
        }
    }
}
