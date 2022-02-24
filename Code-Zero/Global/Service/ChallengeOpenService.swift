//
//  ChallengeService.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/02/21.
//

import Foundation
import Moya

// MARK: - ChallengePreviewData
struct ChallengePreviewData: Codable {
    let convenience: [Convenience]
    let inconvenience: [Convenience]
}

class ChallengeOpenService {
    static let shared = ChallengeOpenService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestChallengeAddPreview(
        token: String,
        completion: @escaping (NetworkResult<ChallengePreviewData>) -> Void
    ) {
        service.request(.challengeOpenPreview(token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<ChallengePreviewData>.self,
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
