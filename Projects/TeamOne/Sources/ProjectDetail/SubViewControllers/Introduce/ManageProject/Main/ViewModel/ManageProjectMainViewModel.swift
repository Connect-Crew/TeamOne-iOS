//
//  ManageProjectMainViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 1/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core
import DSKit

enum ManageProjectMainViewModelNavigation {
    case finish
    case manageApplicants
}

final class ManageProjectMainViewModel: ViewModel {
    
    public init(project: Project) {
        self.project = project
        self.projectSubject.onNext(project)
    }
    
    let memberFacade = DIContainer.shared.resolve(MemberFacade.self)
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
        let closeManageProjectButtonTap: Observable<Void>
        let deleteButtonTap: Observable<Void>
        let completeButtonTap: Observable<Void>
        let finishSubject: Observable<Void>
    }
    
    struct Output {
//        let showDeleteAlert: Observable<Void>
        let showCompleteAlert: PublishSubject<ResultAlertView_Image_Title_Content_Alert>
        let isDeletable: Driver<Bool>
    }
    
    var disposeBag: DisposeBag = .init()
    
    let navigation = PublishSubject<ManageProjectMainViewModelNavigation>()
    
    // MARK: - Alert
    
    lazy var deleteAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "프로젝트를 삭제하시겠습니까?",
        content: "삭제 전 한번 더 고민해보시기 바랍니다.",
        availableCancle: true,
        resultSubject: deleteAlertResultSubject
    )
    
    lazy var completeProjectAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .completeProject,
        title: "프로젝트를 완수하시겠습니까?",
        content: "프로젝트를 마무리하느라 수고하셨습니다!",
        availableCancle: true,
        resultSubject: completeProjectAlertResultSubject
    )
    
    // MARK: - Subject
    
    let project: Project
    
    lazy var projectSubject = BehaviorSubject<Project>(value: Project.noneInfoProject)
    let deleteAlertSubject = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    let completeProjectAlertSubject = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    
    lazy var deleteAlertResultSubject = PublishSubject<Bool>()
    lazy var completeProjectAlertResultSubject = PublishSubject<Bool>()
    
    lazy var projectDeletable = PublishSubject<Bool>()
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        transformNavigation(input: input)
        transformAlert(input: input)
        
        return Output(
//            showDeleteAlert: <#Observable<Void>#>,
            showCompleteAlert: completeProjectAlertSubject,
            isDeletable: projectDeletable.asDriver(onErrorJustReturn: true)
        )
    }
    
    func transformNavigation(input: Input) {
        input.finishSubject
            .map { .finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func transformAlert(input: Input) {
        
        // 프로젝트 완수 버튼 탭시
        input.completeButtonTap
            .withUnretained(self)
            .map { this, _ in
                this.completeProjectAlert
            }
            .bind(to: completeProjectAlertSubject)
            .disposed(by: disposeBag)
        
        // 프로젝트 완수 처리가 faler면 그냥 종료
        completeProjectAlertResultSubject
            .filter { $0 == false }
            .map { _ in .finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        // TODO: - 완수 API 나오면 연결(alert에서 프로젝트 완수 버튼이 선택된 경우)
        completeProjectAlertResultSubject
            .filter { $0 == true }
        
        
        // projectMember가 2명 이상이면 삭제 불가 처리
        // 지울 수 없으면 false
        input.viewDidLoad
            .withLatestFrom(projectSubject)
            .map { $0.id }
            .withUnretained(self)
            .flatMap { this, id in
                this.memberFacade.getProjectMembers(projectId: id)
            }
            .map { $0.count }
            .map { !($0 >= 2) }
            .bind(to: projectDeletable)
            .disposed(by: disposeBag)
    }
}
