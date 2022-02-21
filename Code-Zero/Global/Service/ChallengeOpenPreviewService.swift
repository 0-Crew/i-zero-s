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
    let convenience, inconvenience: [Inconvenience]
}

class ChallengeOpenPreviewService {
    static let shared = ChallengeOpenPreviewService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestChallengeAddPreview(
        token: String,
        completion: @escaping (NetworkResult<ChallengePreviewData>) -> Void
    ) {
        service.request(.myChallengeAdd(token: token)) { result in
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
