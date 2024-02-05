//
//  NetworkEventLogger.swift
//  Network
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import Alamofire

struct NetworkEventLogger: EventMonitor {
    let queue = DispatchQueue(label: "NetworkEventLogger")

    func requestDidFinish(_ request: Request) {
        print("🛰 NETWORK Reqeust LOG")
        print(request.description)
        
        let url = request.request?.url?.absoluteString ?? ""
        let method = request.request?.httpMethod ?? ""
        let headers = "\(request.request?.allHTTPHeaderFields ?? [:])"
        var requestBodyString = "nil"
        var requestBodyJson: [String: Any] = [:]
        
        // httpBody를 문자열로 변환하여 출력
        if let httpBody = request.request?.httpBody {
            if let json = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any] {
                requestBodyJson = json
            } else if let string = String(data: httpBody, encoding: .utf8) {
                requestBodyString = string
            }
        }
        
        
        print(
            "URL: \(url)\n"
            + "Method: \(method)\n"
            + "Headers: \(headers)\n"
            + "RequestBodyString: \(requestBodyString)\n"
            + "RequestBodyJson: \(requestBodyJson)"
        )
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🛰 NETWORK Response LOG")
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
                + "Result: " + "\(response.result)" + "\n"
                + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
                + "Data: \(response.data?.toPrettyPrintedString ?? "")"
        )
    }
}

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
              ) else { return nil }
        return prettyPrintedString as String
    }
}

