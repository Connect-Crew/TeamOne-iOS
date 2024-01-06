//
//  ProjectDetailMainViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Core
import Domain
import RxSwift
import RxCocoa
import DSKit

enum ProjectDetailMainNavigation {
    case back
}

enum ProjectIsMine {
    case mine
    case other
}

final class ProjectDetailMainViewModel: ViewModel {
    
    let projectReportUseCase: ProjectReportUseCase = DIContainer.shared.resolve(ProjectReportUseCase.self)
    
    let projectUseCase: ProjectUseCaseProtocol

    struct Input {
        let viewWillAppear: Observable<Void>
        let backButtonTap: Observable<Void>
        let reportContent: Observable<String>
    }

    struct Output {
        let isMyProject: Driver<Bool>
        let reportResult: Signal<Bool>
        let error: PublishSubject<Error>
    }

    var project: Project!

    public init(projectUseCase: ProjectUseCaseProtocol) {
        self.projectUseCase = projectUseCase
    }

    let type = BehaviorSubject<ProjectIsMine>(value: .other)

    let navigation = PublishSubject<ProjectDetailMainNavigation>()

    var disposeBag: DisposeBag = .init()
    
    let reportResult = PublishSubject<Bool>()
    let error = PublishSubject<Error>()

    func transform(input: Input) -> Output {

        transformProjectInformation(input: input)
        transformNavigation(input: input)
        transformReport(input: input)
        
        return Output(
            isMyProject: type.map { $0 == .mine }.asDriver(
                onErrorJustReturn: false
            ),
            reportResult: reportResult.asSignal(
                onErrorJustReturn: true
            ),
            error: error
        )
    }
    
    func transformProjectInformation(input: Input) {
        // 내 프로젝트인지 구분
        input.viewWillAppear
            .map {
                self.projectUseCase.isMyProject(
                    project: self.project
                )
            }
            .subscribe(onNext: {
                if $0 == true {
                    self.type.onNext(.mine)
                } else {
                    self.type.onNext(.other)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func transformNavigation(input: Input) {
        input.backButtonTap
            .map{ .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func transformReport(input: Input) {
        input.reportContent
            .withUnretained(self)
            .map { this, reportContent in
                return (
                    reportContent: reportContent,
                    projectId: this.project.id
                )
            }
            .withUnretained(self)
            .flatMap { this, report -> Observable<Bool> in
                return this.projectReportUseCase.projectReport(
                    projectId: report.projectId,
                    reason: report.reportContent
                )
                .asObservable()
                .catch { [weak self] error in
                    self?.error.onNext(error)
                    return .empty()
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                this.reportResult.onNext(result)
            })
            .disposed(by: disposeBag)
        
//        let result = input.reportContent
//            .withUnretained(self)
//            .map { this, reportContent in
//                return (
//                    reportContent: reportContent,
//                    projectId: this.project.id
//                )
//            }
//            .withUnretained(self)
//            .flatMap { this, report -> Observable<Result<Bool, Error>> in
//                return this.projectReportUseCase.projectReport(
//                    projectId: report.projectId,
//                    reason: report.reportContent
//                )
//                .asObservable()
//                .asResult()
//            }
//        
//        let getSuccess = result
//            .compactMap { result -> Bool? in
//                guard case .success(let data) = result else { return  nil }
//                
//                return data
//            }
//        
//        let getFailure = result
//            .compactMap { result -> Error? in
//                guard case .failure(let error) = result else { return  nil }
//                
//                return error
//            }
    }
}

