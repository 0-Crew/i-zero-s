//
//  Date+Extension.swift
//  meaning
//
//  Created by 김민희 on 2021/01/01.
//

import Foundation

extension Date {
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

    func getDateIntervalBy(intervalDay: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: intervalDay, to: self)
    }
}
