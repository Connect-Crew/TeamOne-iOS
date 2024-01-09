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

    public var jobMajorCategory: [String] = []

    public var jobSubCategory: [String: [String]] = [:]

    public var skills: [String] = []


    private let baseProjectInformationUseCase: BaseProjectInformationUseCaseProtocol

    private init() {
        self.baseProjectInformationUseCase = DIContainer.shared.resolve(BaseProjectInformationUseCaseProtocol.self)
        loadAndParseData()
    }

    public func configure() {

    }

    private func loadAndParseData() {
        
        self.baseProjectInformationUseCase.baseInformation()
            .subscribe(onNext: { [self] response in

                // MARK: - data
                response.category.forEach {
                    self.data[$0.name] = $0.key
                }

                response.job.forEach { job in

                    jobMajorCategory.append(job.name)
                    jobSubCategory[job.name] = []

                    self.data[job.name] = job.key

                    job.value.forEach { value in
                        self.data[value.name] = value.key
                        self.jobSubCategory[job.name]?.append(value.name)
                    }
                }

                response.region.forEach {
                    self.data[$0.name] = $0.key
                }

                // MARK: - region
                response.region.forEach {
                    self.region[$0.name] = $0.key
                }

                response.skill.forEach {
                    self.skills.append($0)
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
        } else if name == "" {
            return ""
        }
            else {

            print("!!!!!!!!!!!\(self)::::")
            print("KEY ERROR=== \(name)")
            print("!!!!!!!!!!!!")

            return name
        }
    }
}
