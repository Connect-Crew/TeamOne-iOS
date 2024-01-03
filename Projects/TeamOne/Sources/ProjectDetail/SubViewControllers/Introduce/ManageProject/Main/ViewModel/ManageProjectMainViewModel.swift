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
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let closeManageProjectButtonTap: Observable<Void>
        let deleteButtonTap: Observable<Void>
        let completeButtonTap: Observable<Void>
        let finishSubject: Observable<Void>
    }
    
    struct Output {
//        let showDeleteAlert: Observable<Void>
        let showCompleteAlert: PublishSubject<ResultAlertView_Image_Title_Content_Alert>
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
    
    let deleteAlertSubject = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    let completeProjectAlertSubject = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    
    lazy var deleteAlertResultSubject = PublishSubject<Bool>()
    lazy var completeProjectAlertResultSubject = PublishSubject<Bool>()
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        transformNavigation(input: input)
        transformAlert(input: input)
        
        return Output(
//            showDeleteAlert: <#Observable<Void>#>,
            showCompleteAlert: completeProjectAlertSubject
        )
    }
    
    func transformNavigation(input: Input) {
        input.finishSubject
            .map { .finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func transformAlert(input: Input) {
        input.completeButtonTap
            .withUnretained(self)
            .map { this, _ in
                this.completeProjectAlert
            }
            .bind(to: completeProjectAlertSubject)
            .disposed(by: disposeBag)
        
        completeProjectAlertResultSubject
            .filter { $0 == false }
            .map { _ in .finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        completeProjectAlertResultSubject
        // TODO: - 완료 API 나오면 연결
    }
}
