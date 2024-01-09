//
//  String+ISO8601+Extension.swift
//  Core
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public extension String {

    /// "2023-11-04T11:45:54"형식 ISO8601 포멧의 문자열에 사용된다.
    func toRelativeDateString() -> String {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        guard let date = formatter.date(from: self) else { return "Invalid Date" }
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)

        if let year = components.year, year > 0 {
            return "\(year)년 전"
        } else if let month = components.month, month > 0 {
            return "\(month)개월 전"
        } else if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }

    /// "2023-11-04T11:45:54"형식 ISO8601 포멧의 문자열에 사용된다.
    /// 7일이 경과하지 않았으면 true, 경과했으면 false를 리턴합니다.
    func isNewData() -> Bool {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        guard let date = formatter.date(from: self) else { return false }
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)

        if let day = components.day, day <= 7 {
            return true
        } else {
            return false
        }
    }
    
    /**
     "2023-11-04T11:45:54"형식 ISO8601 포멧의 문자열에 사용
     주어진 일 수가 경과하였는지
     - Parameter : 일 수(Int)
     - returns : 경과 하였다면 true 아니라면 false
     */
    func isDateWithin(days: Int) -> Bool {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]

            guard let date = formatter.date(from: self) else { return false }
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.day], from: date, to: now)

            if let day = components.day, day <= days {
                return false
            } else {
                return true
            }
        }

    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter.date(from: self)
    }
}
