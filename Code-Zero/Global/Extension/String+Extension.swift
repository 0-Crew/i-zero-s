//
//  String+Extension.swift
//  meaning
//
//  Created by 김민희 on 2021/01/01.
//

import Foundation

extension String {
    func recordDate(origin: String,
                    change: String) -> String {
        var format = origin
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
