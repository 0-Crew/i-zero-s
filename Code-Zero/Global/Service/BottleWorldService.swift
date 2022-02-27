//
//  BottleWorldService.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/27.
//

import Foundation
import Moya

class BottleWorldService {
    static let shared = BottleWorldService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestBottleWoldBrowser(
        token: String,
        keyword: String?,
        completion: @escaping (NetworkResult<BottleWorldUser>) -> Void
    ) {
        service.request(.bottleWorldBrowse(token: token,
                                           keyworkd: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<BottleWorldUser>.self,
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
