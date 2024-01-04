//
//  AuthInterceptor.swift
//  TeamOneNetwork
//
//  Created by 강현준 on 12/18/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Alamofire
import Core
import Domain
import RxSwift

class AuthInterceptor: RequestInterceptor {

    let disposeBag = DisposeBag()

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("DEBUG: Intercept")
        
        guard let accessToken: String = UserDefaultKeyList.Auth.appAccessToken,
        let _: String = UserDefaultKeyList.Auth.appRefreshToken
        else {
            completion(.success(urlRequest))
            return
        }

        var urlRequest = urlRequest

        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        let expiredCode: Int? = 401
        
        print("DEBUG: RETRY")

        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == expiredCode else {
            print("DEBUG: RETRY Pass")
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("DEBUG: RETRY 실행")
        
        let authRepository = DIContainer.shared.resolve(AuthRepositoryProtocol.self)

        authRepository.reissuance()
            .subscribe(
                onSuccess: { refresh in
                    print("DEBUG: REFRESH 성공")
                    UserDefaultKeyList.Auth.appAccessToken = refresh.token
                    UserDefaultKeyList.Auth.appRefreshToken = refresh.refresh
                    completion(.retry)
                },
                onFailure:  { error in
                    print("DEBUG: REFRESH 실패")
                    // TODO: - 갱신실패 -> 로그인 화면으로 전환 필요
                    completion(.doNotRetryWithError(error))
                }
            )

            .disposed(by: disposeBag)
    }
}
