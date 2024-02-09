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
    case apply(Project)
    case modify(Int)
    case manageApplicants(Project)
}

final class ProjectDetailMainViewModel: ViewModel {
    
    enum ProjectIsMine {
        case other
        case mine
    }
    
    private let projectReportUseCase: ProjectReportUseCase
    private let memberFacade: MemberFacade
    private let projectLikeUseCase: ProjectLikeUseCaseProtocol
    private let projectInfoUseCase: ProjectInfoUseCase
    private let projectUpdateStateUseCase: ProjectUpdateStateUseCase
    private let kickUserFromProjectUseCase: KickUserFromProjectUseCase
    
    public init(
        projectReportUseCase: ProjectReportUseCase,
        memberFacade: MemberFacade,
        projectLikeUseCase: ProjectLikeUseCaseProtocol,
        projectInfoUseCase: ProjectInfoUseCase,
        projectUpdateStateUseCase: ProjectUpdateStateUseCase,
        kickUserFromProjectUseCase: KickUserFromProjectUseCase,
        project: Project
    ) {
        self.projectReportUseCase = projectReportUseCase
        self.memberFacade = memberFacade
        self.projectLikeUseCase = projectLikeUseCase
        self.projectInfoUseCase = projectInfoUseCase
        self.projectUpdateStateUseCase = projectUpdateStateUseCase
        self.kickUserFromProjectUseCase = kickUserFromProjectUseCase
        self.project = BehaviorRelay<Project>(value: project)
    }

    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
        let backButtonTap: Observable<Void>
        let reportContent: Observable<String>
        let profileSelected: Observable<ProjectMember>
        let representProjectSelected: Observable<RepresentProject>
        let likeButtonTap: Observable<Void>
        let applyButtonTap: Observable<Void>
        let expelProps: PublishRelay<(projectId: Int, userId: Int, reasons: [User_ExpelReason])>
        let modifyButtonTap: PublishRelay<Void>
        let manageApplicantsButtonTap: PublishRelay<Void>
        let deleteButtonTap: PublishRelay<Void>
        let completeButtonTap: PublishRelay<Void>
    }

    struct Output {
        let project: Driver<Project>
        let projectMembers: Driver<[ProjectMember]>
        let isMyProject: Driver<Bool>
        let reportResult: Signal<Bool>
        let error: PublishSubject<Error>
        let expelSuccess: PublishRelay<Void>
        let expelFailure: PublishRelay<Error>
        let isDeletable: Driver<Bool>
        let isCompletable: Driver<Bool>
    }

    let type = BehaviorSubject<ProjectIsMine>(value: .other)

    let navigation = PublishSubject<ProjectDetailMainNavigation>()

    var disposeBag: DisposeBag = .init()
    
    let refresh = ProjectDetailCoordinator.refresh
    let project: BehaviorRelay<Project>
    let projectMembers = BehaviorSubject<[ProjectMember]>(value: [])
    let reportResult = PublishSubject<Bool>()
    let error = PublishSubject<Error>()
    let expelSuccess = PublishRelay<Void>()
    let expelFailure = PublishRelay<Error>()
    let isDeletable = BehaviorRelay<Bool>(value: false)
    let isCompletable = BehaviorRelay<Bool>(value: false)

    let changedProject = HomeCoordinator.commonChangedProject

    func transform(input: Input) -> Output {
        
        transformProject()
        transformIsMyProject(viewWillAppear: input.viewWillAppear)
        transformNavigation(input: input)
        transformLike(likeButtonTap: input.likeButtonTap)
        transformReport(input: input)
        transformMemberList(input: input)
        transformUserExple(input: input.expelProps)
        transformDeletableCompletable(input: input)
        transformDelete(deleteTap: input.deleteButtonTap)
        transformComplete(completeTap: input.completeButtonTap)
        
        return Output(
            project: project.asDriver(),
            projectMembers: projectMembers.asDriver(onErrorJustReturn: []),
            isMyProject: type.map { $0 == .mine }.asDriver(
                onErrorJustReturn: false
            ),
            reportResult: reportResult.asSignal(
                onErrorJustReturn: true
            ),
            error: error,
            expelSuccess: expelSuccess,
            expelFailure: expelFailure,
            isDeletable: isDeletable.asDriver(),
            isCompletable: isCompletable.asDriver()
        )
    }
  
    func transformProject() {
        let getProjectResult = Observable.merge(
            refresh
        )
            .withLatestFrom(project)
            .map { project in
                return project.id
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
            .do(onNext: { [weak self] in
                self?.changedProject.onNext($0)
            })
            .bind(to: project)
            .disposed(by: disposeBag)
        
        getFailure
            .bind(to: error)
            .disposed(by: disposeBag)

    }
    
    func transformIsMyProject(viewWillAppear: Observable<Void>) {
        viewWillAppear
            .withLatestFrom(project)
            .withUnretained(self)
            .map { this, project in
                this.projectInfoUseCase.isMyProject(
                    project: project
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
        
        input.applyButtonTap
            .withLatestFrom(project)
            .map { .apply($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.modifyButtonTap
            .withLatestFrom(project)
            .map { $0.id }
            .map { .modify($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.manageApplicantsButtonTap
            .withLatestFrom(project)
            .map { $0 }
            .map { .manageApplicants($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func transformLike(likeButtonTap: Observable<Void>) {
        likeButtonTap
            .withLatestFrom(project)
            .withUnretained(self)
            .flatMap { this, project in
                return this.projectLikeUseCase.like(projectId: project.id)
                    .withLatestFrom(this.project) { like, current in
                        
                        var variable = current
                        
                        if like.project == project.id {
                            variable.favorite = like.favorite
                            variable.myFavorite = like.myFavorite
                        }
                        
                        this.changedProject.onNext(variable)
                        return variable
                    }
            }
            .bind(to: project)
            .disposed(by: disposeBag)
    }
    
    func transformReport(input: Input) {
        input.reportContent
            .withLatestFrom(project) { report, project in
                return (
                    reportContent: report,
                    projectId: project.id
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
        transformGetMembers()
        transformPushRepresentProject(input: input.representProjectSelected)
    }
    
    func transformGetMembers() {
        let getmemberResult = project
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
    
    func transformUserExple(input: PublishRelay<(projectId: Int, userId: Int, reasons: [User_ExpelReason])>) {
        input
            .withUnretained(self)
            .flatMap { this, props in
                return this.kickUserFromProjectUseCase.kickUserFromProject(projectId: props.projectId, userId: props.userId, reasons: props.reasons)
                    .catch { error in
                        this.expelFailure.accept(error)
                        
                        return .never()
                    }
            }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.expelSuccess.accept(())
                this.refresh.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func transformDeletableCompletable(input: Input) {
        // projectMember가 2명 이상이면 삭제 불가 처리
        // 지울 수 없으면 false
        projectMembers
            .map { $0.count }
            .map { !($0 >= 2) }
            .bind(to: isDeletable)
            .disposed(by: disposeBag)
        
        // 2주가 경과하였으면 삭제가능
        project
            .map { $0.createdAt }
            .map { $0.isDateWithin(days: 14) }
            .bind(to: isCompletable)
            .disposed(by: disposeBag)
    }
    
    func transformDelete(deleteTap: PublishRelay<Void>) {
        let result = deleteTap
            .withLatestFrom(project)
            .map { $0.id }
            .withUnretained(self)
            .flatMap { this, id in
                return this.projectUpdateStateUseCase.updateState(projectId: id, state: .deleted)
                    .asObservable()
                    .catch { error in
                        this.error.onNext(error)
                        return .empty()
                    }
            }
            .asResult()
        
        let getSuccess = result
            .compactMap { result -> Void? in
                guard case .success = result else {
                    return nil
                }
                return ()
            }
        
        getSuccess
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                HomeCoordinator.deletedProject.accept(())
                this.navigation.onNext(.back)
            })
            .disposed(by: disposeBag)
        
        let getFailure = result
            .compactMap { result -> Error? in
                guard case .failure(let error) = result else {
                    return nil
                }

                return error
            }
        
        getFailure
            .bind(to: error)
            .disposed(by: disposeBag)
    }
    
    func transformComplete(completeTap: PublishRelay<Void>) {
        let result = completeTap
            .withLatestFrom(project)
            .map { $0.id }
            .withUnretained(self)
            .flatMap { this, id in
                return this.projectUpdateStateUseCase.updateState(projectId: id, state: .completed)
                    .asObservable()
                    .catch { error in
                        this.error.onNext(error)
                        return .empty()
                    }
            }
            .asResult()
        
        let getSuccess = result
            .compactMap { result -> Void? in
                guard case .success = result else {
                    return nil
                }
                return ()
            }
        
        getSuccess
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                HomeCoordinator.deletedProject.accept(())
                this.navigation.onNext(.back)
            })
            .disposed(by: disposeBag)
        
        let getFailure = result
            .compactMap { result -> Error? in
                guard case .failure(let error) = result else {
                    return nil
                }

                return error
            }
        
        getFailure
            .bind(to: error)
            .disposed(by: disposeBag)
    }
}
