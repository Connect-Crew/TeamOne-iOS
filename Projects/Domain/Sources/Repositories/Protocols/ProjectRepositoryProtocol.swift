//
//  ProjectRepositoryProtocol.swift
//  Domain
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectRepositoryProtocol {
    
    func list(lastId: Int?, size: Int, goal: String?, career: String?, region: String?, online: String?, part: String?, skills: String?, states: String?, category: String?, search: String?) -> Observable<[SideProjectListElement]>

    func like(projectId: Int) -> Observable<Like>

    func project(projectId: Int) -> Observable<Project>

    func apply(projectId: Int, part: String, message: String) -> Observable<Bool>
}
