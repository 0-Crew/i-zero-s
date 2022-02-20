//
//  APITarget.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/20.
//

import Foundation
import Moya

enum APITarget {
    // case 별로 api 나누기
    case userNick(nick: String, token: String) // 닉네임 세팅 및 변경
    case auth(id: String, email: String, provider: String)

    // 챌린지
    case myChallengeAdd(token: String)
}

// MARK: TargetType Protocol 구현
extension APITarget: TargetType {
    var baseURL: URL {
        // baseURL - 서버의 도메인
        return URL(string: "https://asia-northeast3-washyourbottle.cloudfunctions.net/api")!
    }

    var path: String {
        // path - 서버의 도메인 뒤에 추가 될 경로
        switch self {
        case .userNick:
            return "/user/name"
        case .auth:
            return "/auth"
        case .myChallengeAdd:
            return "/my-challenge/add"
        }
    }

    var method: Moya.Method {
        // method - 통신 method (get, post, put, delete ...)
        switch self {
        case .userNick, .auth:
            return .post
        case .myChallengeAdd:
            return .get
        }
    }

    var sampleData: Data {
        // sampleDAta - 테스트용 Mock Data
        return Data()
    }

    var task: Task {
        // task - 리퀘스트에 사용되는 파라미터 설정
        // 파라미터가 없을 때는 - .requestPlain
        // 파라미터 존재시에는 - .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)

        switch self {

        case .userNick(let nick, _):
            return .requestParameters(parameters: ["name": nick], encoding: JSONEncoding.default)
        case .auth(let id, let email, let provider):
            return .requestParameters(parameters: ["snsId": id, "email": email, "provider": provider],
                                      encoding: JSONEncoding.default)
        case .myChallengeAdd:
            return .requestPlain
        }
    }
    var validationType: Moya.ValidationType {
        // validationType - 허용할 response의 타입
        return .successAndRedirectCodes
    }

    var headers: [String: String]? {
        // headers - HTTP header
        switch self {
        case .userNick(_, let token):
            return ["Content-Type": "application/json", "Authorization": token]
        case .myChallengeAdd(let token):
            return ["Content-Type": "application/json", "Authorization": token]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
