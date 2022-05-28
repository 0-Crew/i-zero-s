//
//  UserPrivateService.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/21.
//

import Foundation
import Moya

struct AuthPrivate: Codable {
    let isPrivate: Bool
}

class UserPrivateService {
    static let shared = UserPrivateService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func toggleAccountPrivate(token: String,
                                     completion: @escaping (NetworkResult<AuthPrivate>) -> Void) {

        service.request(APITarget.userPrivate(token: token)) { result in
            switch result {

            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(GenericResponse<AuthPrivate>.self, from: response.data)
                    if let data = body.data {
                        completion(.success(data))
                    }
                } catch let error {
                    debugPrint(error)
                }
            case .failure(let error):
                let errorCode = error.response?.statusCode
                switch errorCode {
                case 400, 401:
                    completion(.serverErr)
                case 500:
                    completion(.networkFail)
                default:
                    completion(.requestErr(error.response?.description ?? ""))
                }
                debugPrint(error)
            }
        }
    }
}
