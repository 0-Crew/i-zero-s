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
                if error.response?.statusCode == 400 {
                    completion(.requestErr("duplicateNick"))
                }
                debugPrint(error)
            }
        }
    }
}
