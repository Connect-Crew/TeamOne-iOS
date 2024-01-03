//
//  ProjectManageCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 1/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject
import Domain

enum ManageProjectCoordinatorResult {
    case finish
}

final class ManageProjectCoordinator: BaseCoordinator<ManageProjectCoordinatorResult> {

    let finish = PublishSubject<ManageProjectCoordinatorResult>()
    
    let project: Project
    let needRefreshSubject: PublishSubject<Void>
    
    init(_ navigationController: UINavigationController, project: Project, needRefreshSubject: PublishSubject<Void>) {
        self.project = project
        self.needRefreshSubject = needRefreshSubject
        super.init(navigationController)
    }

    override func start() -> Observable<ManageProjectCoordinatorResult> {
        showManage()
        return finish
    }

    func showManage() {
        
        
    }
}
