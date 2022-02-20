//
//  SignInVC.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/19.
//

import UIKit
import AuthenticationServices

class SignInVC: UIViewController {

    // MARK: - @IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var appleLoginView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!

    // MARK: - @IBAction
    @IBAction func loginButtonDidTap(_ sender: Any) {

    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        socialLoginSetting()
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
}

// MARK: - Login Function
extension SignInVC {
    func socialLoginSetting() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(appleLoginViewDidTap(sender:)))
        appleLoginView.addGestureRecognizer(tapGesture)
    }
    @objc func appleLoginViewDidTap(sender: UITapGestureRecognizer) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }

    func requestLogin(id: String, email: String, provider: String) {
        UserLoginService.shared.requestLogin(id: id,
                                             email: email,
                                             provider: provider) { [weak self] result in
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
// MARK: - ASAuthorizationControllerDelegate
extension SignInVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            UserDefaults.standard.set(user, forKey: "appleId")
            if let email = credential.email { // 회원가입 시
                requestLogin(id: user, email: email, provider: "apple")
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else {return}
             switch error.code {
             case .canceled:
                 print("Canceled")
             case .unknown:
                 print("Unknow")
             case .invalidResponse:
                 print("invalid Respone")
             case .notHandled:
                 print("Not Handled")
             case .failed:
                 print("Failed")
             default:
                 print("Default")
             }
    }
}
