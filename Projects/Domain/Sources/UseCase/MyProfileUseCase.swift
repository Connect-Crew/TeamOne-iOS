//
//  MyProfileUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Core
import RxSwift

public protocol MyProfileUseCaseProtocol {
    func myProfile() -> Observable<MyProfile>
}

public struct MyProfileUseCase: MyProfileUseCaseProtocol {

    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    @discardableResult
    public func myProfile() -> Observable<MyProfile> {
        return self.userRepository.myProfile()
            .do(onNext: { myProfile in
                UserDefaultKeyList.User.id = myProfile.id
                UserDefaultKeyList.User.nickname = myProfile.nickname
                UserDefaultKeyList.User.profileImageURL = myProfile.profile
                UserDefaultKeyList.User.introduction = myProfile.introduction
                UserDefaultKeyList.User.temperature = myProfile.temperature
                UserDefaultKeyList.User.responseRate = myProfile.responseRate
                UserDefaultKeyList.User.parts = myProfile.parts

                print("!!!!!!!!!!!\(self):::::::::")
                print(myProfile)
                print("!!!!!!!!!!!!")
            }, onError: {
                print("!!!!!!!!!!!\(self)::::")
                print($0)
                print("!!!!!!!!!!!!")
            })
    }
}
