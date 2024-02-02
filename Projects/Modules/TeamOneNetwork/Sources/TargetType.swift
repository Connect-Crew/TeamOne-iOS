//
//  TargetType.swift
//  Network
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias JSONEncoding = Alamofire.JSONEncoding

public protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var header: HTTPHeaders { get }
    var path: String { get }
    var parameters: RequestParams? { get }
    var encoding: ParameterEncoding { get }
}

public extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        // var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        // appendingPathComponent 사용 시 path 내 ?를 %3f로 인식하여 임시 처리
        var urlRequest = try URLRequest(url: url.absoluteString + path, method: method)
        urlRequest.headers = header

        switch parameters {
            
        case let .query(request):
            let params = request?.toDictionary() ?? [:]
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            return urlRequest
            
        case let .body(request):
            let params = request?.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            return try encoding.encode(urlRequest, with: params)
            
        case let .plainText(request):
            let params = request?.toDictionary() ?? [:]
            
            
            return try encoding.encode(urlRequest, with: params)
        case .none:
            return urlRequest
        }
    }
    
    func asMultipartRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = try URLRequest(url: url, method: method)
        urlRequest.headers = header
        
        urlRequest.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        let formData = MultipartFormData()
        
        switch parameters {
        case let .body(parameters):
            if let parameters = parameters {
                for (key, value) in parameters.toDictionary() {
                    if let data = "\(value)".data(using: .utf8) {
                        formData.append(data, withName: key)
                    }
                }
            }
        default:
            break
        }
        
        urlRequest.httpBody = try formData.encode()
        
        return urlRequest
    }
}

public enum RequestParams {
    case query(_ parameter: Encodable?)
    case body(_ parameter: Encodable?)
    case plainText(_ parameter: Encodable?)
}
