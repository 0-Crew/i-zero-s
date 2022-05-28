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
    case userPrivate(token: String)
    case auth(idKey: String, token: String, provider: String)

    // 보틀월드
    case bottleWorldBrowse(token: String, keyword: String?)
    case bottleWorldFollower(token: String, keyword: String?)
    case bottleWorldFollowing(token: String, keyword: String?)

    // 챌린지
    case challengeOpenPreview(token: String)
    case challengeOpen(
        convenienceString: String,
        inconvenienceString: String,
        isFromToday: Bool,
        token: String
    )

    // 설정
    case userInfo(token: String)
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
        case .userPrivate:
            return "/user/private"
        case .challengeOpenPreview, .challengeOpen:
            return "/my-challenge/add"
        case .bottleWorldBrowse:
            return "/bottleworld/browse"
        case .bottleWorldFollower:
            return "/bottleworld/follower"
        case .bottleWorldFollowing:
            return "/bottleworld/following"
        case .userInfo:
            return "/user/setting"
        }
    }

    var method: Moya.Method {
        // method - 통신 method (get, post, put, delete ...)
        switch self {
        case .userNick, .auth, .challengeOpen:
            return .post
        case .userPrivate:
            return .put
        case .challengeOpenPreview, .bottleWorldBrowse, .userInfo:
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
        case .auth(let idKey, let token, let provider):
            return .requestParameters(parameters: ["idKey": idKey, "token": token, "provider": provider],
                                      encoding: JSONEncoding.default)
        case .userPrivate:
                return .requestPlain
        case .bottleWorldBrowse(_, let keyword),
                .bottleWorldFollower(_, let keyword),
                .bottleWorldFollowing(_, let keyword):
            guard let keyword = keyword else {
                return .requestPlain
            }
            return .requestParameters(parameters: ["keyword": keyword],
                                      encoding: URLEncoding.queryString)
        case .challengeOpenPreview, .userInfo:
            return .requestPlain
        case .challengeOpen(let convenienceString, let inconvenienceString, let isFromToday, _):
            return .requestParameters(parameters: ["convenienceString": convenienceString,
                                                   "inconvenienceString": inconvenienceString,
                                                   "isfromToday": isFromToday],
                                      encoding: JSONEncoding.default
            )
        }
    }
    var validationType: Moya.ValidationType {
        // validationType - 허용할 response의 타입
        return .successAndRedirectCodes
    }

    var headers: [String: String]? {
        // headers - HTTP header
        switch self {
        case .userNick(_, let token),
                .userPrivate(let token),
                .challengeOpenPreview(let token),
                .challengeOpen(_, _, _, let token),
                .bottleWorldBrowse(let token, _),
                .bottleWorldFollower(let token, _),
                .bottleWorldFollowing(let token, _):
                .userInfo(let token):
            return ["Content-Type": "application/json",
                    "Authorization": token]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
