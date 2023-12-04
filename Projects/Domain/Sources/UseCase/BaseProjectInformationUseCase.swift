//
//  BaseProjectInformationUseCase.swift
//  Domain
//
//  Created by 강현준 on 12/4/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol BaseProjectInformationUseCaseProtocol {
    func baseInformation() -> Observable<BaseProjectInfoParameters>
}

public struct BaseProjectInformationUseCase: BaseProjectInformationUseCaseProtocol {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }

    public func baseInformation() -> Observable<BaseProjectInfoParameters> {
        return projectRepository.baseInformation()
    }
}
