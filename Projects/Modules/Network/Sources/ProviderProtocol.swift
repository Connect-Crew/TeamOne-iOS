//
//  ProviderProtocol.swift
//  Network
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Alamofire
import RxSwift

public protocol ProviderProtocol: AnyObject {
//    func request<Success: Decodable, Error: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<GenericAPIResponse<Success, Error>>
    
    func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T>
}

