//
//  MainChallengeService.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/06/21.
//

import Foundation
import Moya

struct MainChallengeData: Codable {
    let user: UserInfo?
    let myFollowings: [User]?
    let isFollowing: Bool?
    let myChallenge: UserChallenge?
    let myInconveniences: [Convenience]
    let inconvenience: [Convenience]?

    var isChallengeTermExpired: Bool {
        return myChallenge?.isDueDateOver ?? false
    }
}

struct MyInconvenienceFinishData: Codable {
    let myInconvenience: Convenience?
}

struct MyInconvenienceUpdateData: Codable {
    let myInconvenience: [Convenience]
}

struct EmptiedChallengeData: Codable {
    let myChallenge: UserChallenge?
}

class MainChallengeService {
    static let shared = MainChallengeService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestMyChallenge(
        token: String,
        completion: @escaping (NetworkResult<MainChallengeData>) -> Void
    ) {
        service.request(.myChallengeFetch(token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<MainChallengeData>.self,
                        from: response.data
                    )
                    if let data = body.data {
                        completion(.success(data))
                    }
                } catch let error {
                    debugPrint(error)
                }
            case .failure(let error):
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }

    public func requestCompleteMyInconvenience(
        token: String,
        inconvenience: Convenience,
        completion: @escaping (NetworkResult<(Bool, Convenience?)>) -> Void
    ) {
        let request: APITarget = .myInconvenienceFinish(
            token: token,
            myInconvenienceId: inconvenience.id
        )
        service.request(request) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<MyInconvenienceFinishData>.self,
                        from: response.data
                    )
                    if let data = body.data {
                        completion(.success((body.success, data.myInconvenience)))
                    }
                } catch let error {
                    debugPrint(error)
                    completion(.serverErr)
                }
            case .failure(let error):
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }

    public func requestUpdateMyInconvenienceText(
        token: String,
        inconvenience: Convenience,
        willChangingText: String,
        completion: @escaping (NetworkResult<(Bool, Convenience?)>) -> Void
    ) {
        let request: APITarget = .myInconvenienceUpdate(
            token: token,
            myInconvenienceId: inconvenience.id,
            inconvenienceString: willChangingText
        )
        service.request(request) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<MyInconvenienceUpdateData>.self,
                        from: response.data
                    )
                    if let data = body.data {
                        completion(.success((body.success, data.myInconvenience.first)))
                    }
                } catch let error {
                    completion(.serverErr)
                    debugPrint(error)
                }
            case .failure(let error):
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }

    public func requestUserChallenge(
        token: String,
        userId: Int,
        completion: @escaping (NetworkResult<MainChallengeData>) -> Void
    ) {
        service.request(.myChallengeUser(token: token, userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<MainChallengeData>.self,
                        from: response.data
                    )
                    if let data = body.data {
                        completion(.success(data))
                    }
                } catch let error {
                    debugPrint(error)
                }
            case .failure(let error):
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }

    public func requestEmptyBottle(
        token: String,
        myChallengeId id: Int,
        completion: @escaping (NetworkResult<Bool>) -> Void
    ) {
        service.request(.myChallengeEmpty(token: token, myChallengeId: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<EmptiedChallengeData>.self,
                        from: response.data
                    )
                    if let isFinished = body.data?.myChallenge?.isFinished {
                        completion(.success(isFinished))
                    } else {
                        completion(.success(false))
                    }
                } catch let error {
                    debugPrint(error)
                }
            case .failure(let error):
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }

}
