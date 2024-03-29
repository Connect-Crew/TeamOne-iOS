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

    let authInterceptor = AuthInterceptor()

    private let session: Session

    public init(session: Session) {
        self.session = session
    }

    public static let `default`: Provider = {
        let configuration = URLSessionConfiguration.af.default
        let networkEventLogger = NetworkEventLogger()
        let session = Session(configuration: configuration, eventMonitors: [networkEventLogger])
        return Provider(session: session)
    }()

    public func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {

        return Observable.create { emitter in
            Loading.start()

            let request = self.session
                .request(urlConvertible,
                         interceptor: self.authInterceptor)
                .validate(statusCode: 200 ..< 300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(data):
                        emitter.onNext(data)
                    case let .failure(error):
                        if let errorData = response.data {
                            do {
                                let networkError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)

                                let apiError = APIError(error: networkError)

                                emitter.onError(apiError)
                            } catch {
                                emitter.onError(APIError.decodingError)
                            }
                        } else {
                            emitter.onError(APIError.unknown)
                        }
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

    public func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Single<T> {
        return Single.create { single in
            
            Loading.start()

            let request = self.session
                .request(urlConvertible,
                         interceptor: self.authInterceptor)
                .validate(statusCode: 200 ..< 300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(data):
                        single(.success(data))
                    case let .failure(error):
                        if let errorData = response.data {
                            do {
                                let networkError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)

                                let apiError = APIError(error: networkError)

                                single(.failure(apiError))
                            } catch {
                                single(.failure(APIError.unknown))
                            }
                        } else {
                            single(.failure(APIError.unknown))
                        }
                    }
                    
                    Loading.stop()

                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func request(_ urlConvertible: URLRequestConvertible) -> Single<Void> {
        return Single.create { single in
            
            Loading.start()

            let request = self.session
                .request(urlConvertible,
                         interceptor: self.authInterceptor)
                .validate(statusCode: 200 ..< 300)
                .response() { response in 
                    switch response.result {
                    case .success:
                        single(.success(()))
                    case .failure:
                        if let errorData = response.data {
                            do {
                                let networkError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)

                                let apiError = APIError(error: networkError)

                                single(.failure(apiError))
                            } catch {
                                single(.failure(APIError.unknown))
                            }
                        } else {
                            single(.failure(APIError.unknown))
                        }
                    }
                    
                    Loading.stop()

                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func requestNoInterceptor<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Single<T> {
        return Single.create { single in
            let request = self.session
                .request(urlConvertible)
                .validate(statusCode: 200 ..< 300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(data):
                        single(.success(data))
                    case let .failure(error):
                        if let errorData = response.data {
                            do {
                                let networkError = try JSONDecoder().decode(ErrorEntity.self, from: errorData)

                                let apiError = APIError(error: networkError)

                                single(.failure(apiError))
                            } catch {
                                single(.failure(APIError.decodingError))
                            }
                        } else {
                            single(.failure(error))
                        }
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

