//
//  String+Extension.swift
//  meaning
//
//  Created by 김민희 on 2021/01/01.
//

import Foundation

extension String {

    // origin 포맷에서 change 포맷의 시간 string으로 바꿔주는 함수
    func recordDate(origin: String,
                    change: String) -> String {
        /*
         origin : 원래 시간 string의 포맷을 적어주세요
         change : 바꾸고 싶은 시간 string의 포맷을 적어주세요
         */
        let format = origin
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        guard let tempDate = formatter.date(from: self) else {
            return ""
        }
        formatter.dateFormat = change
        return formatter.string(from: tempDate)
    }
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil

        }

    }
}
