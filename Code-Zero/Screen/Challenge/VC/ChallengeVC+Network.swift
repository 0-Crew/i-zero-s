//
//  ChallengeVC+Network.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/06/28.
//

import UIKit

// MARK: - Network
extension ChallengeVC {
    internal func fetchUserInfoData() {
        guard let token = accessToken else { return }
        UserSettingService.shared.requestUserInfo(token: token) { [weak self] result in
            switch result {
            case .success(let info):
                self?.userInfo = info.user
                self?.nickNameLabel.text = info.user.name
            case .requestErr(let error):
                print(error)
            case .serverErr:
                // 토큰 만료(자동 로그아웃 느낌..)
                self?.changeRootViewToHome()
            case .networkFail:
                // TODO: 서버 자체 에러 - 서버 점검 중 popup 제작?
                break
            }
        }
    }

    internal func fetchMyChallenge() {
        guard let token = accessToken else { return }
        Indicator.shared.show()
        MainChallengeService
            .shared
            .requestMyChallenge(token: token) { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.challengeBackgroundView.alpha = 1
                        self?.challengeData = data

                        let challenge = data.myChallenge
                        let myInconveniences = data.myInconveniences
                        let inconveniences = data.inconvenience ?? []

                        self?.followingPeopleList = data.myFollowings ?? []
                        self?.bindChallenge(
                            challenge: challenge,
                            inconveniences: myInconveniences,
                            conveniences: inconveniences
                        )
                        Indicator.shared.dismiss()
                    }
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }

    internal func fetchUserChallenge(userId: Int?) {
        guard let token = accessToken, let userId = userId else { return }
        Indicator.shared.show()
        MainChallengeService
            .shared
            .requestUserChallenge(token: token, userId: userId) { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.challengeBackgroundView.alpha = 1
                        self?.challengeData = data
                        let userInfo = data.user
                        let challenge = data.myChallenge
                        let myInconveniences = data.myInconveniences
                        let isFollowing = data.isFollowing ?? false
                        let inconveniences = data.inconvenience ?? []

                        self?.userInfo = userInfo
                        self?.nickNameLabel.text = userInfo?.name ?? ""
                        self?.followingPeopleList = data.myFollowings ?? []
                        self?.updateSocialButtons(isFollowing: isFollowing)
                        self?.bindChallenge(
                            challenge: challenge,
                            inconveniences: myInconveniences,
                            conveniences: inconveniences
                        )
                        Indicator.shared.dismiss()
                    }
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }

    internal func toggleInconvenienceComplete(
        inconvenience: Convenience,
        completion: @escaping (Bool, Convenience?) -> Void
    ) {
        guard let token = accessToken else { return }
        Indicator.shared.show()
        MainChallengeService
            .shared
            .requestCompleteMyInconvenience(token: token, inconvenience: inconvenience) { result in
                switch result {
                case .success((let isSuccess, let inconvenience)):
                    DispatchQueue.main.async {
                        completion(isSuccess, inconvenience)
                    }
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
                Indicator.shared.dismiss()
            }
    }

    internal func updateInconvenience(
        inconvenience: Convenience,
        willChangingText: String,
        completion: @escaping (Bool, Convenience?) -> Void
    ) {
        guard let token = accessToken else { return }
        Indicator.shared.show()
        MainChallengeService
            .shared
            .requestUpdateMyInconvenienceText(
                token: token,
                inconvenience: inconvenience,
                willChangingText: willChangingText
            ) { result in
                switch result {
                case .success((let isSuccess, let inconvenience)):
                    DispatchQueue.main.async {
                        completion(isSuccess, inconvenience)
                    }
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
                Indicator.shared.dismiss()
            }
    }

    internal func cheerUpUser(completion: @escaping (Bool) -> Void) {
        guard let token = accessToken, let userId = fetchedUserId else { return }
        Indicator.shared.show()
        AlarmCenterService
            .shared
            .requestNotificationButton(
                token: token,
                type: .cheer,
                receiverUserId: userId
            ) { result in
                switch result {
                case .success(let isSuccess):
                    completion(isSuccess)
                    print("응원하기 성공")
                case .requestErr(let message):
                    completion(false)
                    print(message)
                case .serverErr:
                    completion(false)
                    print("serverErr")
                case .networkFail:
                    completion(false)
                    print("networkFail")
                }
                Indicator.shared.dismiss()
            }
    }

    internal func toggleFollow(completion: @escaping (Bool) -> Void) {
        guard let userID = fetchedUserId, let token = accessToken else { return }

        BottleWorldService.shared.makeBottleworldFollow(
            token: token,
            id: userID
        ) { result in
            switch result {
            case .success(let isSuccess):
                completion(isSuccess)
            case .requestErr(let message):
                print(message)
                completion(false)
            case .networkFail, .serverErr:
                completion(false)
            }
        }
    }
}
