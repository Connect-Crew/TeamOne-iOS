//
//  ApplyBottomSheetViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain
import Core
import TeamOneNetwork
import DSKit

enum ApplyNavigation {
    case close
}

final class ApplyViewModel: ViewModel {

    let applyUseCase: ProjectApplyUseCaseProtocol
    let projectUseCase: ProjectUseCaseProtocol

    init(applyUseCase: ProjectApplyUseCaseProtocol, projectUseCase: ProjectUseCaseProtocol) {
        self.applyUseCase = applyUseCase
        self.projectUseCase = projectUseCase
    }

    struct Input {
        let close: Observable<Void>
        let applyPartTap: Observable<RecruitStatus>
        let applicationText: Observable<String>
        let applyButtonTap: Observable<Void>
    }

    struct Output {
        let project: Driver<Project?>
        let showWriteApplication: PublishSubject<RecruitStatus>
        let showResult: Signal<Bool>
        let showError: PublishSubject<ResultAlertView_Image_Title_Content_Alert>
    }

    let navigation = PublishSubject<ApplyNavigation>()
    
    // MARK: - Alert
    
    lazy var errorAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "에러",
        content: "",
        availableCancle: false,
        resultSubject: errorResultSubject
    )
    
    // MARK: - Subject

    let project = BehaviorSubject<Project?>(value: nil)
    let selectPart = PublishSubject<RecruitStatus>()
    let refresh = PublishSubject<Void>()
    let showResult = PublishSubject<Bool>()
    let showError = PublishSubject<ResultAlertView_Image_Title_Content_Alert>()
    
    let errorResultSubject = PublishSubject<Bool>()
    
    var disposeBag: DisposeBag = .init()

    func transform(input: Input) -> Output {

        input.close
            .map { .close }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.applyPartTap
            .bind(to: selectPart)
            .disposed(by: disposeBag)

        input.applyButtonTap
            .withLatestFrom(
                Observable.combineLatest(
                    project.compactMap { $0 },
                    selectPart.asObservable()
                )
            )
            .map {
                return (projectid: $0.0.id, part: $0.1.part)
            }
            .withLatestFrom(input.applicationText) { applyPart, message in
                return (projectid: applyPart.projectid, part: applyPart.part, message: message)
            }
            .withUnretained(self)
            .flatMap { viewModel, apply in
                viewModel.applyUseCase.apply(projectId: apply.projectid, part: KM.shared.key(name: apply.part), message: apply.message)
            }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.showResult.onNext(true)
            }, onError: { [weak self] error in
                
                guard let self = self else { return }
                
                let error = error as? APIError
                switch error {
                case .network(_, let message):
                    self.errorAlert.title = message
                case .notToken:
                    break
                case .unknown:
                    self.errorAlert.title = "알수없는 에러"
                case .none:
                    break
                }
                
                self.showError.onNext(self.errorAlert)
            })
            .disposed(by: disposeBag)

        return Output(
            project: project.asDriver(onErrorJustReturn: nil),
            showWriteApplication: selectPart,
            showResult: showResult.asSignal(onErrorJustReturn: false),
            showError: showError
        )
    }
}
