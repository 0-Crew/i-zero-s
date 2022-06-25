//
//  ViewController.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/11.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser

class HomeVC: UIViewController {

    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var onboardingButton: UIButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    @IBAction func onboardingButtonDidTap() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard
            let onboardingStepOneVC = storyboard.instantiateViewController(
                withIdentifier: "OnboardingStepOneVC"
            ) as? OnboardingStepOneVC else { return }
        navigationController?.pushViewController(onboardingStepOneVC, animated: true)
    }

    @IBAction func kakaoSignInButtonDidTap() {
        kakaoLoginViewDidTap()
    }
    @IBAction func appleSignInButtonDidTap() {
        appleLoginViewDidTap()
    }

}

extension HomeVC {
    private func initView() {
        appTitleLabel.setTextWithLineHeight(lineHeight: 54)
        appTitleLabel.setTextLetterSpacing(letterSpacing: 1.35)
        appDescriptionLabel.setTextWithLineHeight(lineHeight: 21)

        onboardingButton.setBorder(borderColor: .white, borderWidth: 1.0)
    }
}

// MARK: - Login Function
extension HomeVC {
    private func requestLogin(id: String, token: String, provider: String) {
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
    private func moveChallengeVC() {
        let storybard = UIStoryboard(name: "Challenge", bundle: nil)
        let challengeVC = storybard.instantiateViewController(withIdentifier: "Challenge")
        UIApplication.shared.windows.first?.replaceRootViewController(
            challengeVC,
            animated: true,
            completion: nil
        )
    }
    private func moveNickSettingVC() {
        guard let nickSettingVC = storyboard?.instantiateViewController(withIdentifier: "NickSettingVC")
        else { return }
        navigationController?.pushViewController(nickSettingVC, animated: true)
    }
}

// MARK: - KaKao
extension HomeVC {
    private func kakaoLoginViewDidTap() {
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
    private func kakaoLoginSuccess(token: String) {
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
extension HomeVC: ASAuthorizationControllerDelegate {
    private func appleLoginViewDidTap() {
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
            UserDefaults.standard.set(credential.user,
                                      forKey: "appleId")
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
