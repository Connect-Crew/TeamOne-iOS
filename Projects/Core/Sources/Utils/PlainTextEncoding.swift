//
//  PlainTextEncoding.swift
//  Core
//
//  Created by 강현준 on 2/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Alamofire

public struct PlainTextEncoding: ParameterEncoding {
    public static var `default`: PlainTextEncoding { return PlainTextEncoding() }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        switch parameters {
        case let .some(params):
            if let string = params.values.first as? String {
                request.httpBody = string.data(using: .utf8)
                request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            }
        default:
            break
        }
        return request
    }
}
