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

}
