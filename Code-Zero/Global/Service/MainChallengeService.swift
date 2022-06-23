//
//  MainChallengeService.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/06/21.
//

import Foundation
import Moya

struct MyChallengeData: Codable {
    let myFollowings: [User]
    let myChallenge: UserChallenge?
    let myInconveniences: [Convenience]
    let inconvenience: [Convenience]
}

struct MyInconvenienceFinishData: Codable {
    let myInconvenience: Convenience?
}

struct MyInconvenienceUpdateData: Codable {
    let myInconvenience: [Convenience]
}

class MainChallengeService {
    static let shared = MainChallengeService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestMyChallenge(
        token: String,
        completion: @escaping (NetworkResult<MyChallengeData>) -> Void
    ) {
        service.request(.myChallengeFetch(token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<MyChallengeData>.self,
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

}
