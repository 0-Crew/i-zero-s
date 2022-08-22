//
//  Date+Extension.swift
//  meaning
//
//  Created by 김민희 on 2021/01/01.
//

import Foundation

extension Date {

    var isToday: Bool {
        let todayDate = Date().datePickerToString(format: "yyyy-MM-dd")
        return todayDate == datePickerToString(format: "yyyy-MM-dd")
    }

    func datePickerToString(format: String) -> String {
        // date 타입을 string으로 바꾸기

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)

        return dateString
    }

    func dayNumberOfWeek() -> Int? {
        // 날짜에 맞는 요일 찾는 함수 (1 일요일 ~ 7 토요일)
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }

    /// 오늘기준으로 intervalDay일 전, 후의 날짜를 구하는 함수
    func getDateIntervalBy(intervalDay: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: intervalDay, to: self)
    }

    /// 오늘 기준 시간 차를 단위 별(분, 시간, 일)로 계산하는 함수
    func getTimeLineDate() -> String {
        let timeGap = -self.timeIntervalSinceNow

        let oneDaySecond = 86400.0
        if timeGap > oneDaySecond {
            let dayGap = ceil(timeGap/oneDaySecond)
            return "\(Int(dayGap))일"
        }

        let oneHourSecond = 3600.0
        if timeGap > oneHourSecond {
            let dayGap = floor(timeGap/oneHourSecond)
            return "\(Int(dayGap))시간"
        }

        if timeGap > 60 {
            let dayGap = floor(timeGap/60.0)
            return "\(Int(dayGap))분"
        }

        return "방금"
    }
}
