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

enum ProjectDetailMainNavigation {
    case back
    case profile
    // 대표 프로젝트로 이동
    case pushRepresentProejct(Project)
}

final class ProjectDetailMainViewModel: ViewModel {
    
    enum ProjectIsMine {
        case other
        case mine
    }
    
    private let projectReportUseCase: ProjectReportUseCase = DIContainer.shared.resolve(ProjectReportUseCase.self)
    
    private let memberFacade: MemberFacade = DIContainer.shared.resolve(MemberFacade.self)
    
    private let projectInfoUseCase: ProjectInfoUseCase

    struct Input {
        let viewWillAppear: Observable<Void>
        let backButtonTap: Observable<Void>
        let reportContent: Observable<String>
        let profileSelected: Observable<ProjectMember>
        let representProjectSelected: Observable<RepresentProject>
    }

    struct Output {
        let project: Driver<Project>
        let projectMembers: Driver<[ProjectMember]>
        let isMyProject: Driver<Bool>
        let reportResult: Signal<Bool>
        let error: PublishSubject<Error>
    }

    var project: Project!

    public init(projectUseCase: ProjectInfoUseCase) {
        self.projectInfoUseCase = projectUseCase
    }

    let type = BehaviorSubject<ProjectIsMine>(value: .other)

    let navigation = PublishSubject<ProjectDetailMainNavigation>()

    var disposeBag: DisposeBag = .init()
    
    let projectSubject = BehaviorSubject<Project>(value: Project.noneInfoProject)
    let projectMembers = BehaviorSubject<[ProjectMember]>(value: [])
    let reportResult = PublishSubject<Bool>()
    let error = PublishSubject<Error>()

    func transform(input: Input) -> Output {
        
        transformProject(input: input.viewWillAppear)
        transformIsMyProject(input: input)
        transformNavigation(input: input)
        transformReport(input: input)
        transformMemberList(input: input)
        
        return Output(
            project: projectSubject.asDriver(onErrorJustReturn: Project.noneInfoProject),
            projectMembers: projectMembers.asDriver(onErrorJustReturn: []),
            isMyProject: type.map { $0 == .mine }.asDriver(
                onErrorJustReturn: false
            ),
            reportResult: reportResult.asSignal(
                onErrorJustReturn: true
            ),
            error: error
        )
    }
    
    func transformProject(input: Observable<Void>) {
        let getProjectResult = input
            .take(1)
            .withUnretained(self)
            .map { this, _ in
                return this.project.id
            }
            .withUnretained(self)
            .flatMap { this, id in
                return this.projectInfoUseCase.project(projectId: id)
                    .retry(3)
                    .asObservable()
                    .asResult()
            }
        
        let getSuceess = getProjectResult
            .compactMap { result -> Project? in
                guard case .success(let data) = result else { return nil }
                
                return data
            }
        
        let getFailure = getProjectResult
            .compactMap { result -> Error? in
                guard case .failure(let error) = result else { return nil }
                
                return error
            }
        
        getSuceess
            .bind(to: projectSubject)
            .disposed(by: disposeBag)
        
        // TODO: - getfailure 에러처리
    }
    
    func transformIsMyProject(input: Input) {
        input.viewWillAppear
            .withUnretained(self)
            .map { this, _ in
                this.projectInfoUseCase.isMyProject(
                    project: this.project
                )
            }
            .withUnretained(self)
            .subscribe(onNext: { this, bool in
                if bool == true {
                    this.type.onNext(.mine)
                } else {
                    this.type.onNext(.other)
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
    }
        
    func transformMemberList(input: Input) {
        transformGetMembers(input: input.viewWillAppear)
        transformPushRepresentProject(input: input.representProjectSelected)
    }
    
    func transformGetMembers(input: Observable<Void>) {
        let getmemberResult = input
            .withUnretained(self)
            .map { this, _ in
                return this.project
            }
            .compactMap { $0 }
            .map { $0.id }
            .withUnretained(self)
            .flatMap { this, id in
                this.memberFacade.getProjectMembers(projectId: id)
                    .asObservable()
                    .asResult()
            }
        
        let getMemberSuccess = getmemberResult
            .compactMap { result -> [ProjectMember]? in
                guard case .success(let data) = result else { return nil }
                
                return data
            }
        
        let getMemberFail = getmemberResult
            .compactMap { result -> Error? in
                guard case .failure(let error) = result else { return nil }
                
                return error
            }
        
        getMemberSuccess
            .bind(to: projectMembers)
            .disposed(by: disposeBag)
        
        getMemberFail
            .bind(to: error)
            .disposed(by: disposeBag)
    }
    
    func transformPushRepresentProject(input: Observable<RepresentProject>) {
        
        let projectResult = input
            .withUnretained(self)
            .flatMap { this, project in
                this.projectInfoUseCase.project(projectId: project.id)
                    .asObservable()
                    .asResult()
            }
        
        let getProjectSuccess = projectResult
            .compactMap { result -> Project? in
                guard case .success(let project) = result else {
                    return nil
                }
                
                return project
            }
        
        let getProjectFailure = projectResult
            .compactMap { reult -> Error? in
                guard case .failure(let error) = reult else {
                    return nil
                }
                
                return error
            }
        
        getProjectSuccess
            .map { .pushRepresentProejct($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        getProjectFailure
            .bind(to: error)
            .disposed(by: disposeBag)
    }
}
