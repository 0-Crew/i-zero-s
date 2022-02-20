//
//  UserNickService.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/20.
//

import Foundation
import Moya

struct TokenDate: Codable {
    let accesstoken: String
}

class UserLoginService {
    static let shared = UserLoginService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestLogin(id: String,
                             email: String,
                             provider: String,
                             completion: @escaping (NetworkResult<GenericResponse<TokenDate>>) -> Void) {

        service.request(APITarget.auth(id: id, email: email, provider: provider)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(GenericResponse<TokenDate>.self, from: response.data)
                    completion(.success(body))

                } catch let error {
                    debugPrint(error)
                }
            case .failure(let error):
                // 에러 처리 부분
                if error.errorCode == 500 {
                    completion(.networkFail)
                }
                completion(.serverErr)
            }
        }
    }
}
