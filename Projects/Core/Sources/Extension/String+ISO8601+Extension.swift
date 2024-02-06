//
//  String+ISO8601+Extension.swift
//  Core
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public extension String {

    /**
     "2023-11-04T11:45:54"형식 ISO8601 포멧의 문자열에 사용된다.
     - returns: n년전, n개월전, n일전, n시간 전, n분 전, 방금 전
     */
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

    /**
     "2023-11-04T11:45:54"형식 ISO8601 포멧의 문자열에 사용된다.
     - returns: 7일이 경과했다면 true, 그렇지 않다면 false를 반환합니다.
     */
    func isNewData() -> Bool {
        
        print("DEBUG: CreatedAt::: \(self) ")
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: self) else {
            return false
        }
        
        let calendar = Calendar.current
        if let dateSevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) {
            return date <= dateSevenDaysAgo
        }
        
        return false
    }
    
    /**
     "2023-11-04T11:45:54" 형식의 ISO8601 포맷 문자열에 사용됩니다.
     - Parameter days: 확인할 일 수.
     - returns: 주어진 일 수가 경과했다면 true, 그렇지 않다면 false를 반환합니다.
     */
    func isDateWithin(days: Int) -> Bool {
        let formatter = ISO8601DateFormatter()
        // 시간 정보를 무시하는 옵션으로 설정
        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        
        guard let date = formatter.date(from: self) else { return false }
        let calendar = Calendar.current
        
        // 입력된 날짜와 현재 날짜를 '날짜만'으로 비교하기 위해 시간을 자정으로 설정
        let startOfGivenDate = calendar.startOfDay(for: date)
        let startOfCurrentDate = calendar.startOfDay(for: Date())
        
        let components = calendar.dateComponents([.day], from: startOfGivenDate, to: startOfCurrentDate)
        
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
    
    /**
     "2023-11-04T11:45:54" 형식의 ISO8601 포맷 문자열에 사용됩니다.
     - Parameter : self
     - returns: yyyy.mm.dd 형식의 String
     */
    func toFormattedDateString() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}
