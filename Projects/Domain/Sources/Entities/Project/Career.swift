//
//  Career.swift
//  Domain
//
//  Created by 강현준 on 1/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public enum Career: CaseIterable {
    case none
    case seeker
    case entry
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case tenPlus
    
    public func toString() -> String {
        switch self {
        case .none:
            "경력무관"
        case .seeker:
            "준비생"
        case .entry:
            "신입"
        case .one:
            "1년"
        case .two:
            "2년"
        case .three:
            "3년"
        case .four:
            "4년"
        case .five:
            "5년"
        case .six:
            "6년"
        case .seven:
            "7년"
        case .eight:
            "8년"
        case .nine:
            "9년"
        case .tenPlus:
            "10년+"
        }
    }
    
    public func toMultiPartValue() -> String {
        switch self {
        case .none:
            "NONE"
        case .seeker:
            "SEEKER"
        case .entry:
            "ENTRY"
        case .one:
            "YEAR_1"
        case .two:
            "YEAR_2"
        case .three:
            "YEAR_3"
        case .four:
            "YEAR_4"
        case .five:
            "YEAR_5"
        case .six:
            "YEAR_6"
        case .seven:
            "YEAR_7"
        case .eight:
            "YEAR_8"
        case .nine:
            "YEAR_9"
        case .tenPlus:
            "YEAR_10_PLUS"
        }
    }
    
    public static func allCareerStringValues() -> [String] {
        return Self.allCases.map { $0.toString() }
    }
    
    public static func findCareer(string: String) -> Career {
        return Self.allCases.first { $0.toString() == string }!
    }
}
