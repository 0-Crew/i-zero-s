//
//  UserNickService.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/20.
//

import Foundation
import Moya

class UserLoginService {
    static let shared = UserLoginService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestLogin(id: String,
                             token: String,
                             provider: String,
                             code: String?,
                             completion: @escaping (NetworkResult<UserLoginData>) -> Void) {

        service.request(APITarget.auth(idKey: id,
                                       token: token,
                                       provider: provider,
                                       authorizationCode: code)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<UserLoginData>.self,
                        from: response.data
                    )
                    guard let data = body.data else { return }
                    completion(.success(data))
                } catch let error {
                    debugPrint(error)
                }
            case .failure(let error):
                // 에러 처리 부분
                if error.errorCode == 500 {
                    completion(.networkFail)
                }
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }
    public func deleteUser(token: String,
                           completion: @escaping (NetworkResult<String>) -> Void) {
        service.request(.deleteAuth(token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<DeleteUser>.self,
                        from: response.data
                    )
                    guard let data = body.data?.user.provider else { return }
                    completion(.success(data))
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
