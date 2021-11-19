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
}