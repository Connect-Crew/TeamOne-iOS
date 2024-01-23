//
//  ListAllApplicationsProjectResponse.swift
//  Data
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct ListAllApplicationsProjectResponseDTO: Codable {

    var parts: [String: AppllyStatusReponseDTO]

    public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            parts = try container.decode([String: AppllyStatusReponseDTO].self)
        }
    
    func toDomain() -> [ApplyStatus] {
        
        var result = [ApplyStatus]()
        
        for dic in parts {
            
            let status = ApplyStatus(
                partKey: dic.key,
                applies: dic.value.applies,
                current: dic.value.current,
                max: dic.value.max
            )
            
            result.append(status)
        }
        
        return result
    }
}
