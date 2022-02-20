//
//  MoyaLoggingPlugin.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/20.
//

import Foundation
import Moya

final class MoyaLoggingPlugin: PluginType {
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        let requestURL = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var requestLog = "--------------\n\n[\(method)] \(requestURL)\n\n--------------\n"
        requestLog.append("API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            requestLog.append("header: \(headers)\n")
        }
        if let body = httpRequest.httpBody,
            let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            requestLog.append("\(bodyString)\n")
        }
        requestLog.append("------------------- END \(method) --------------------------")
        print(requestLog)
    }

    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSuceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }

    func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let requestURL = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var requestLog = "------------------- 네트워크 통신 성공 -------------------"
        requestLog.append("\n[\(statusCode)] \(requestURL)\n------------------\n")
        requestLog.append("API: \(target)\n")
        response.response?.allHeaderFields.forEach {
            requestLog.append("\($0): \($1)\n")
        }
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            requestLog.append("\(reString)\n")
        }
        requestLog.append("------------- END HTTP (\(response.data.count)-byte body) -------------")
        print(requestLog)
    }

    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuceed(response, target: target, isFromError: true)
            return
        }
        var requestLog = "네트워크 오류"
        requestLog.append("<-- \(error.errorCode) \(target)\n")
        requestLog.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        requestLog.append("<-- END HTTP")
        print(requestLog)
    }
}
