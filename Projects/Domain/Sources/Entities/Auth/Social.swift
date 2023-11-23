//
//  Social.swift
//  Core
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum Social {
    case kakao
    case apple
    case google

    public var toString: String {
        switch self {
        case .apple: return "APPLE"
        case .kakao: return "KAKAO"
        case .google: return "GOOGLE"
        }
    }

    public init?(from string: String) {
        switch string {
        case "APPLE":
            self = .apple
        case "KAKAO":
            self = .kakao
        case "GOOGLE":
            self = .google
        default:
            return nil
        }
    }

}
