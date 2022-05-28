//
//  UserSettingService.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/28.
//

import Foundation
import Moya

class UserSettingService {
    static let shared = UserSettingService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func changeUserNick(
        nick: String,
        token: String,
        completion: @escaping (NetworkResult<SimpleData>) -> Void
    ) {
        service.request(.userNick(nick: nick,
                                  token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        SimpleData.self,
                        from: response.data
                    )
                    completion(.success(body))
                } catch let error {
                    debugPrint(error)
                }
            case .failure(let error):
                let errorCode = error.response?.statusCode
                switch errorCode {
                case 400:
                    completion(.requestErr("duplicateNick"))
                case 500:
                    completion(.networkFail)
                default:
                    completion(.serverErr)
                }
                debugPrint(error)
            }
        }
    }

    public func requestUserInfo(token: String,
                                completion: @escaping (NetworkResult<SettingData>) -> Void
    ) {
        service.request(APITarget.userInfo(token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<SettingData>.self,
                        from: response.data
                    )
                    guard let data = body.data else { return }
                    completion(.success(data))
                } catch let error {
                    debugPrint(error)
                }
            case .failure(let error):
                // 에러 처리 부분
                guard let response = error.response else { return }
                if response.statusCode == 500 {
                    completion(.networkFail)
                    return
                }
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }
}
