//
//  CalendarService.swift
//  Code-Zero
//
//  Created by 미니 on 2022/05/29.
//

import Foundation
import Moya

struct CalendarData: Codable {
    let myChallenges: [UserChallenge]
    let selectedChallenge: SelectedChallenge

    var challengeContext: [ChallengeData] {
        return myChallenges.map {
            var list: [DayChallengeState]?
            if $0.id == selectedChallenge.myChallenge?.id {
                list = selectedChallenge.dayChallengeStateList
            } else {
                list = nil
            }
            return ChallengeData(subject: $0.name, list: list, id: $0.id)
        }
    }
}

struct SelectedChallenge: Codable {
    let myChallenge: UserChallenge?
    let myInconveniences: [Convenience]?

    var dayChallengeStateList: [DayChallengeState]? {
        guard let myInconveniences = myInconveniences else {
            return nil
        }
        return myInconveniences.map { $0.dayChallengeState }
    }
}

class CalendarService {
    static let shared = CalendarService()
    private lazy var service = MoyaProvider<APITarget>(plugins: [MoyaLoggingPlugin()])

    public func requestCalendar(
        myChallengeId: Int?,
        token: String,
        completion: @escaping (NetworkResult<CalendarData>) -> Void
    ) {
        service.request(.calendar(id: myChallengeId,
                                  token: token)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let body = try decoder.decode(
                        GenericResponse<CalendarData>.self,
                        from: response.data
                    )
                    guard let data = body.data else { return }
                    completion(.success(data))
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
}
