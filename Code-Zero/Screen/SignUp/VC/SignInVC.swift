//
//  SignInVC.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/19.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser

class SignInVC: UIViewController {

    // MARK: - @IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var kakaoLoginView: UIView!
    @IBOutlet weak var appleLoginView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!

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
        let appleTapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(appleLoginViewDidTap(sender:)))
        let kakaoTapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(kakaoLoginViewDidTap(sender:)))
        appleLoginView.addGestureRecognizer(appleTapGesture)
        kakaoLoginView.addGestureRecognizer(kakaoTapGesture)
    }
    func requestLogin(id: String, token: String, provider: String) {
        UserLoginService.shared.requestLogin(id: id,
                                             token: token,
                                             provider: provider) { [weak self] result in
            switch result {
            case .success(let data):
                data.type == "login" ? self?.moveChallengeVC() : self?.moveNickSettingVC()
            case .requestErr(let error):
                print(error)
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("serverErr")
            }
        }
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
    func moveNickSettingVC() {
        guard let nickSettingVC = storyboard?.instantiateViewController(withIdentifier: "NickSettingVC")
        else { return }
        navigationController?.pushViewController(nickSettingVC, animated: true)
    }
}

// MARK: - KaKao
extension SignInVC {
    @objc func kakaoLoginViewDidTap(sender: UITapGestureRecognizer) {
        switch UserApi.isKakaoTalkLoginAvailable() {
        case true:
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error) }
                if let oauthToken = oauthToken {
                    self.kakaoLoginSuccess(token: oauthToken.accessToken)
                }
            }
        case false:
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error) }
                if let oauthToken = oauthToken {
                    self.kakaoLoginSuccess(token: oauthToken.accessToken)
                }
            }
        }
    }
    func kakaoLoginSuccess(token: String) {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error) }
            if let user = user {
                self.requestLogin(id: "\(user.id ?? 0)", token: token, provider: "kakao")
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate & Apple
extension SignInVC: ASAuthorizationControllerDelegate {
    @objc func appleLoginViewDidTap(sender: UITapGestureRecognizer) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = credential.identityToken,
           let tokenString = String(data: identityToken, encoding: .utf8) {
            requestLogin(id: credential.user,
                         token: tokenString,
                         provider: "apple")
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
