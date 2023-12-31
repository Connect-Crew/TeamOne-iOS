//
//  DomainGenericAPIResponse.swift
//  Domain
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum DomainGenericAPIResponse<Success,Error> {
    case success(Success)
    case failure(Error)
}
