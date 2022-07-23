//
//  OnboardingStepFourVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/01/25.
//

import UIKit
import AuthenticationServices
import KakaoSDKUser
import Lottie
import SnapKit

class OnboardingStepFourVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var kakaoLoginView: UIView!
    @IBOutlet weak var appleLoginView: UIView!

    override func viewDidLoad() {
        initView()
    }
    private func initView() {
        let appleTapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(appleLoginViewDidTap(sender:)))
        let kakaoTapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(kakaoLoginViewDidTap(sender:)))
        appleLoginView.addGestureRecognizer(appleTapGesture)
        kakaoLoginView.addGestureRecognizer(kakaoTapGesture)
        animationView.play()
    }

    private func requestLogin(id: String, token: String, provider: String) {
        UserLoginService.shared.requestLogin(
            id: id,
            token: token,
            provider: provider
        ) { [weak self] result in
            switch result {
            case .success(let data):
                UserDefaultManager.shared.saveAccessToken(accessToken: data.accesstoken)
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
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let nickSettingVC = storyboard.instantiateViewController(withIdentifier: "NickSettingVC")
        navigationController?.pushViewController(nickSettingVC, animated: true)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension OnboardingStepFourVC: ASAuthorizationControllerDelegate {
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

// MARK: - KaKao
extension OnboardingStepFourVC {
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
