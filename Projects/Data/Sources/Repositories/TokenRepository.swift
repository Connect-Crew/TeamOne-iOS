//
//  TokenRepository.swift
//  Data
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public struct TokenRepository: TokenRepositoryProtocol {

    enum TokenError: Error {
        case noToken
        case saveFail
        case deleteFail
        case decode
    }

    var keychainManager: KeychainManagerProtocol

    public init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }

    public func save(_ auth: Authorization) -> Observable<Authorization> {
        return Observable.create { emitter in
            guard let data = try? JSONEncoder().encode(auth) else
            {
                emitter.onError(TokenError.decode)
                return Disposables.create()
            }

            guard keychainManager.save(key: .authorization, data: data) || keychainManager.update(key: .authorization, data: data) else
            {
                emitter.onError(TokenError.saveFail)
                return Disposables.create()
            }

            emitter.onNext(auth)

            return Disposables.create()
        }
    }

    public func load() -> Observable<Authorization> {
        return Observable.create { emitter in
            guard let data = keychainManager.load(key: .authorization),
                  let auth = try? JSONDecoder().decode(Authorization.self, from: data) else
            {
                emitter.onError(TokenError.noToken)
                return Disposables.create()
            }

            emitter.onNext(auth)
            return Disposables.create()
        }
    }

    public func deleteAuth() -> Observable<Void> {
        return Observable.create { emitter in
            if keychainManager.delete(key: .authorization) {
                emitter.onNext(())
            } else {
                emitter.onError(TokenError.deleteFail)
            }
            return Disposables.create()
        }
    }
}
