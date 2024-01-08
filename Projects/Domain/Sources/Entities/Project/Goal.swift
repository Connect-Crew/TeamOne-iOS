//
//  Purpose.swift
//  Domain
//
//  Created by 강현준 on 12/8/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum Goal: CaseIterable{
    case none
    case startup
    case portfolio
    
    public func toMultiPartValue() -> String {
        switch self {
        case .none:
            fatalError()
        case .startup:
            return "STARTUP"
        case .portfolio:
            return "PORTFOLIO"
        }
    }
    
    public func toCellString() -> String {
        switch self {
        case .none:
            "NONE"
        case .startup:
            "예비창업"
        case .portfolio:
            "포트폴리오"
        }
    }
    
    public static func findCellStringToPurpose(string: String) -> Goal {
        if let purpose = Self.allCases.first(where: { $0.toCellString() == string }) {
            return purpose
        } else {
            fatalError("\(string) is not founded")
        }
    }
}
