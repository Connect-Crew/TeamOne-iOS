//
//  Provider.swift
//  Network
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift
import Core

public struct EmptyResponse: Decodable {}
public struct EmptyParameter: Encodable {}

public class Provider: ProviderProtocol {
    private let session: Session

    public init(session: Session) {
        self.session = session
    }

    public static let `default`: Provider = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let networkEventLogger = NetworkEventLogger()
        let session = Session(configuration: configuration, eventMonitors: [networkEventLogger])
        return Provider(session: session)
    }()

//    public func request<Success: Decodable, Error: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<GenericAPIResponse<Success, Error>> {
//
//        Loading.start()
//
//        return Observable.create { emitter in
//            let request = self.session
//                .request(urlConvertible)
//                .validate()
//                .responseJSON { response in
//                    switch response.result {
//                    case .success(let value):
//                        do {
//                            let data = try JSONSerialization.data(withJSONObject: value)
//                            let successResponse = try JSONDecoder().decode(Success.self, from: data)
//                            emitter.onNext(.success(successResponse))
//                            emitter.onCompleted()
//                        } catch {
//                            emitter.onError(error)
//                        }
//                    case .failure(_):
//                        if let data = response.data {
//                            do {
//                                let errorResponse = try JSONDecoder().decode(Error.self, from: data)
//                                emitter.onNext(.failure(errorResponse))
//                                emitter.onCompleted()
//                            } catch {
//                                emitter.onError(error)
//                            }
//                        } else {
//                            emitter.onError(response.error ?? AFError.responseValidationFailed(reason: .dataFileNil))
//                        }
//                    }
//
//                    Loading.stop()
//                }
//            return Disposables.create {
//                request.cancel()
//            }
//        }
//    }

    public func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {

        Loading.start()
        
        return Observable.create { emitter in
            let request = self.session
                .request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .responseDecodable(of: T.self) { response in
                    print("@@@@@@@@ REST API \(urlConvertible.urlRequest?.url?.absoluteString ?? "") @@@@@@@@")
                    switch response.result {
                    case let .success(data):
                        emitter.onNext(data)
                    case let .failure(error):
                        emitter.onError(error)
                    }

                    Loading.stop()
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    public func request(_ urlConvertible: URLRequestConvertible) -> Observable<Void> {
        return Observable.create { emitter in
            let request = self.session
                .request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .response() { response in
                    print("@@@@@@@@ REST API \(urlConvertible.urlRequest?.url?.absoluteString ?? "") @@@@@@@@")
                    switch response.result {
                    case .success:
                        emitter.onNext(())
                    case let .failure(error):
                        emitter.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

