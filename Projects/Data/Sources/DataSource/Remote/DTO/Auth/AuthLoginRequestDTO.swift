//
//  AuthLoginRequestDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct AuthLoginRequestDTO: Encodable {
    let token: String
    let social: String
    let fcm: String 

    public init(token: String, social: String, fcm: String) {
        self.token = token
        self.social = social
        self.fcm = fcm
    }
}
