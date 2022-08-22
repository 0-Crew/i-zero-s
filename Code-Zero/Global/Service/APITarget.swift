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
    case auth(idKey: String, token: String, provider: String, authorizationCode: String?)
    case deleteAuth(token: String)

    // 보틀월드
    case bottleWorldBrowse(token: String, keyword: String?)

    // 메인 챌린지
    case myChallengeFetch(token: String)
    case myInconvenienceFinish(token: String, myInconvenienceId: Int)
    case myInconvenienceUpdate(token: String, myInconvenienceId: Int, inconvenienceString: String)
    case myChallengeUser(token: String, userId: Int)
    case myChallengeEmpty(token: String, myChallengeId: Int)

    // 챌린지
    case challengeOpenPreview(token: String)
    case challengeOpen(
        convenienceString: String,
        inconvenienceString: String,
        isFromToday: Bool,
        token: String
    )
    case myCalendar(challengeId: Int?, token: String)
    case userCalendar(challengeId: Int?, userId: Int, token: String)

    // 알람센터
    case notificationButton(token: String, alarmType: AlarmType, receiverUserId: Int)

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
        case .deleteAuth:
            return "/user"
        case .auth:
            return "/auth"
        case .userPrivate:
            return "/user/private"
        case .challengeOpenPreview, .challengeOpen:
            return "/my-challenge/add"
        case .myCalendar:
            return "/my-challenge/calendar"
        case .userCalendar:
            return "/my-challenge/user/calendar"
        case .bottleWorldBrowse:
            return "/bottleworld/browse"
        case .userInfo:
            return "/user/setting"
        case .myChallengeFetch, .myChallengeEmpty:
            return "/my-challenge/main"
        case .myChallengeUser:
            return "/my-challenge/user"
        case .myInconvenienceFinish:
            return "/my-inconvenience/finish"
        case .myInconvenienceUpdate:
            return "/my-inconvenience/update"
        case .notificationButton:
            return "/notification/button"
        }
    }

    var method: Moya.Method {
        // method - 통신 method (get, post, put, delete ...)
        switch self {
        case .userNick, .auth, .challengeOpen, .notificationButton:
            return .post
        case .userPrivate, .myInconvenienceFinish, .myInconvenienceUpdate, .myChallengeEmpty:
            return .put
        case .challengeOpenPreview, .bottleWorldBrowse, .myCalendar, .userCalendar,
                .userInfo, .myChallengeFetch, .myChallengeUser:
            return .get
        case .deleteAuth:
            return .delete

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
        case .auth(let idKey, let token, let provider, let authorizationCode):
            return .requestParameters(parameters: ["idKey": idKey,
                                                   "token": token,
                                                   "provider": provider,
                                                   "authorizationCode": authorizationCode],
                                      encoding: JSONEncoding.default)
        case .userPrivate, .deleteAuth:
                return .requestPlain
        case .bottleWorldBrowse(_, let keyword):
            guard let keyword = keyword else {
                return .requestPlain
            }
            return .requestParameters(parameters: ["keyword": keyword],
                                      encoding: URLEncoding.queryString)
        case .challengeOpenPreview, .userInfo, .myChallengeFetch:
            return .requestPlain
        case .challengeOpen(let convenienceString, let inconvenienceString, let isFromToday, _):
            return .requestParameters(parameters: ["convenienceString": convenienceString,
                                                   "inconvenienceString": inconvenienceString,
                                                   "isfromToday": isFromToday],
                                      encoding: JSONEncoding.default
            )
        case .myCalendar(let challengeId, _):
            guard let challengeId = challengeId else {
                return .requestPlain
            }
            return .requestParameters(parameters: ["myChallengeId": challengeId],
                                      encoding: URLEncoding.queryString)
        case .userCalendar(let challengeId, let userId, _):
            guard let challengeId = challengeId else {
                return .requestParameters(parameters: ["userId": userId],
                                          encoding: URLEncoding.queryString)
            }

            return .requestParameters(parameters: ["myChallengeId": challengeId,
                                                   "userId": userId],
                                      encoding: URLEncoding.queryString)
        case .myInconvenienceFinish(_, let myInconvenienceId):
            return .requestParameters(parameters: ["myInconvenienceId": myInconvenienceId],
                                      encoding: JSONEncoding.default)
        case .myInconvenienceUpdate(_, let myInconvenienceId, let inconvenienceString):
            return .requestParameters(parameters: ["myInconvenienceId": myInconvenienceId,
                                                   "inconvenienceString": inconvenienceString],
                                      encoding: JSONEncoding.default)
        case .myChallengeUser(_, let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case .notificationButton(_, let alarmType, let receiverUserId):
            return .requestParameters(parameters: ["type": alarmType.rawValue,
                                                   "receiverUserId": receiverUserId],
                                      encoding: URLEncoding.queryString)
        case .myChallengeEmpty(_, let myChallengeId):
            return .requestParameters(parameters: ["myChallengeId": myChallengeId],
                                      encoding: URLEncoding.queryString)
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
                .myCalendar(_, let token),
                .userCalendar(_, _, let token),
                .bottleWorldBrowse(let token, _),
                .userInfo(let token),
                .myChallengeFetch(let token),
                .myInconvenienceFinish(let token, _),
                .myInconvenienceUpdate(let token, _, _),
                .myChallengeUser(let token, _),
                .deleteAuth(let token),
                .notificationButton(let token, _, _),
                .myChallengeEmpty(let token, _):
            return ["Content-Type": "application/json",
                    "Authorization": token]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
