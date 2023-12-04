//
//  KeyMapper.swift
//  Domain
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Core


public class KM {

    public static let shared = KM()

    private let disposeBag = DisposeBag()
    private var data: [String: String] = [:]
    private var region: [String: String] = [:]


    private let baseProjectInformationUseCase: BaseProjectInformationUseCaseProtocol

    private init() {
        self.baseProjectInformationUseCase = DIContainer.shared.resolve(BaseProjectInformationUseCaseProtocol.self)
        loadAndParseData()
    }

    public func configure() {

    }

    private func loadAndParseData() {
        
        self.baseProjectInformationUseCase.baseInformation()
            .subscribe(onNext: { response in

                // MARK: - data
                response.category.forEach {
                    self.data[$0.name] = $0.key
                }

                response.job.forEach {
                    self.data[$0.name] = $0.key
                    $0.value.forEach {
                        self.data[$0.name] = $0.key
                    }
                }

                response.region.forEach {
                    self.data[$0.name] = $0.key
                }

                // MARK: - region
                response.region.forEach {
                    self.region[$0.name] = $0.key
                }
            })
            .disposed(by: disposeBag)
    }

    public func getRegion() -> [String] {
        return region.map { $0.key }
    }

    public func key(name: String) -> String {
        if let key = data[name] {
            return key
        } else {

            print("!!!!!!!!!!!\(self)::::")
            print("KEY ERROR")
            print("!!!!!!!!!!!!")

            return name
        }
    }
}
