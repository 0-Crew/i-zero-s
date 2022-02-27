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

    // 보틀월드 둘러보기 API
    public func requestBottleWoldBrowser(
        token: String,
        keyword: String?,
        completion: @escaping (NetworkResult<[BottleWorldUser]>) -> Void
    ) {
        service.request(.bottleWorldBrowse(token: token,
                                           keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<[BottleWorldUser]>.self,
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

    // 보틀월드 팔로워 목록 API
    public func requestBottleWoldFollower(
        token: String,
        keyword: String?,
        completion: @escaping (NetworkResult<[BottleWorldUser]>) -> Void
    ) {
        service.request(.bottleWorldFollower(token: token,
                                             keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<[BottleWorldUser]>.self,
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
