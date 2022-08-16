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

    var isOverDate: Bool {
        let todmorrowDate = Date().getDateIntervalBy(intervalDay: 1)
        guard
            let tomorrowDateString = todmorrowDate?.datePickerToString(format: "yyyy-MM-dd")
        else {
            return false
        }
        let endDate = self.datePickerToString(format: "yyyy-MM-dd")

        return tomorrowDateString == endDate
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
}
