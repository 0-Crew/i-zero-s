//
//  AlarmCenterService.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/06/28.
//

import Foundation
import Moya

class AlarmCenterService {
    static let shared = AlarmCenterService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    internal func requestNotificationButton(
        token: String,
        type: AlarmType,
        receiverUserId: Int,
        completion: @escaping (NetworkResult<Bool>) -> Void
    ) {
        let request: APITarget = .notificationButton(
            token: token,
            alarmType: type,
            receiverUserId: receiverUserId
        )
        service.request(request) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        SimpleData.self,
                        from: response.data
                    )
                    completion(.success(body.success))
                } catch let error {
                    debugPrint(error)
                    completion(.requestErr(error.localizedDescription))
                }
            case .failure(let error):
                completion(.serverErr)
                debugPrint(error)
            }
        }
    }
}
