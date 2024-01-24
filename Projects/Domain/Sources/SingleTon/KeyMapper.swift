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
    
    private var regionLookup: [String: String] = [:]
    private var jobLookup: [String: String] = [:]
    private var categoryLookup: [String: String] = [:]
    private var jobValueLookup: [String: (parentKey: String, parentName: String)] = [:]
    
    private let baseProjectInformationUseCase: BaseProjectInformationUseCaseProtocol
    
    private init() {
        self.baseProjectInformationUseCase = DIContainer.shared.resolve(BaseProjectInformationUseCaseProtocol.self)
        loadAndParseData()
    }
    
    private func loadAndParseData() {
        
        self.baseProjectInformationUseCase.baseInformation()
            .subscribe(onNext: { [self] response in
                
                // Region 매핑
                response.region.forEach { category in
                    regionLookup[category.name] = category.key
                    regionLookup[category.key] = category.name
                }
                
                // Job 및 Job Value 매핑
                response.job.forEach { job in
                    
                    jobLookup[job.name] = job.key
                    jobLookup[job.key] = job.name
                    
                    jobMajorCategory.append(job.name)
                    jobSubCategory[job.name] = []
                    
                    self.data[job.name] = job.key
                    
                    job.value.forEach { value in
                        
                        self.data[value.name] = value.key
                        self.jobSubCategory[job.name]?.append(value.name)
                        
                        jobLookup[value.name] = value.key
                        jobLookup[value.key] = value.name
                        
                        jobValueLookup[value.key] = (parentKey: job.key, parentName: job.name)
                    }
                }
                
                response.category.forEach { category in
                    self.data[category.name] = category.key
                    categoryLookup[category.name] = category.key
                    regionLookup[category.key] = category.name
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
    
    // name으로 key 찾기
    public func findKeyByName(name: String) -> String {
        
        if let name = regionLookup[name] {
            return name
        } else if let name = jobLookup[name] {
            return name
        } else {
            assert(true)
            return name
        }
    }
    
    // key로 name 찾기
    public func findNameByKey(key: String) -> String {
        
        if let name = regionLookup[key] {
            return name
        } else if let name = jobLookup[key] {
            return name
        } else {
            assert(true)
            return key
        }
    }
    
    // 소분류에서 대분류 찾기
    public func findParentCategoryBySubKey(subKey: String) -> (parentKey: String, parentName: String) {
        
        if let parrent = jobValueLookup[subKey] {
            return parrent
        } else {
            assert(true)
            return (parentKey: "???", parentName: "????")
        }
        
    }
}
