//
//  UserInfoService.swift
//  Code-Zero
//
//  Created by Hailey on 2022/05/25.
//

import Foundation
import Moya

class UserInfoService {
    static let shared = UserInfoService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestLogin(token: String,
                             completion: @escaping (NetworkResult<SettingData>) -> Void) {

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
                if error.errorCode == 500 {
                    completion(.networkFail)
                }
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }
}
