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
    case manageProject(Project)
}

final class ProjectDetailMainViewModel: ViewModel {
    
    enum ProjectIsMine {
        case other
        case mine
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let projectReportUseCase: ProjectReportUseCase
    private let memberFacade: MemberFacade
    private let projectLikeUseCase: ProjectLikeUseCaseProtocol
    private let projectInfoUseCase: ProjectInfoUseCase
    
    private var project: Project
    
    public init(
        projectReportUseCase: ProjectReportUseCase,
        memberFacade: MemberFacade,
        projectLikeUseCase: ProjectLikeUseCaseProtocol,
        projectInfoUseCase: ProjectInfoUseCase,
        project: Project
    ) {
        self.projectReportUseCase = projectReportUseCase
        self.memberFacade = memberFacade
        self.projectLikeUseCase = projectLikeUseCase
        self.projectInfoUseCase = projectInfoUseCase
        self.project = project
        
        projectSubject.onNext(project)
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
        let manageButtonTap: Observable<Void>
        let expelProps: PublishRelay<UserExpelProps>
    }

    struct Output {
        let project: Driver<Project>
        let projectMembers: Driver<[ProjectMember]>
        let isMyProject: Driver<Bool>
        let reportResult: Signal<Bool>
        let error: PublishSubject<Error>
        let expelSuccess: PublishRelay<Void>
        let expelFailure: PublishRelay<Error>
    }

    let type = BehaviorSubject<ProjectIsMine>(value: .other)

    let refresh = PublishSubject<Void>()
    let navigation = PublishSubject<ProjectDetailMainNavigation>()

    var disposeBag: DisposeBag = .init()
    
    let refresh = PublishSubject<Void>()

    let projectSubject = BehaviorSubject<Project>(value: Project.noneInfoProject)
    let projectMembers = BehaviorSubject<[ProjectMember]>(value: [])
    let reportResult = PublishSubject<Bool>()
    let error = PublishSubject<Error>()

    let changedProject = PublishSubject<Project>()

    let expelSuccess = PublishRelay<Void>()
    let expelFailure = PublishRelay<Error>()

    func transform(input: Input) -> Output {
        
        transformRefreshProject()
        transformIsMyProject(viewWillAppear: input.viewWillAppear)
        transformNavigation(input: input)
        transformLike(likeButtonTap: input.likeButtonTap)
        transformReport(input: input)
        transformMemberList(input: input)
        transformUserExple(input: input.expelProps)
        
        return Output(
            project: projectSubject.asDriver(
                onErrorJustReturn: Project.noneInfoProject
            ),
            projectMembers: projectMembers.asDriver(onErrorJustReturn: []),
            isMyProject: type.map { $0 == .mine }.asDriver(
                onErrorJustReturn: false
            ),
            reportResult: reportResult.asSignal(
                onErrorJustReturn: true
            ),
            error: error,
            expelSuccess: expelSuccess,
            expelFailure: expelFailure
        )
    }
    
    func transformRefreshProject() {
        let getProjectResult = Observable.merge(refresh)
    }
  
    func transformProject(input: Observable<Void>) {
        let getProjectResult = Observable.merge(
            input.take(1),
            refresh
        )
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
            .do(onNext: { [weak self] in
                self?.changedProject.onNext($0)
            })
            .bind(to: projectSubject)
            .disposed(by: disposeBag)
        
        getFailure
            .bind(to: error)
            .disposed(by: disposeBag)
    }
    
    func transformIsMyProject(viewWillAppear: Observable<Void>) {
        viewWillAppear
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
        
        input.manageButtonTap
            .withLatestFrom(projectSubject)
            .map { .manageProject($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.applyButtonTap
            .withLatestFrom(projectSubject)
            .map { .apply($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func transformLike(likeButtonTap: Observable<Void>) {
        likeButtonTap
            .withLatestFrom(projectSubject)
            .withUnretained(self)
            .flatMap { this, project in
                return this.projectLikeUseCase.like(projectId: project.id)
                    .withLatestFrom(this.projectSubject) { like, current in
                        
                        var variable = current
                        
                        if like.project == project.id {
                            variable.favorite = like.favorite
                            variable.myFavorite = like.myFavorite
                        }
                        
                        this.changedProject.onNext(variable)
                        return variable
                    }
            }
            .bind(to: projectSubject)
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
        transformGetMembers(input: projectSubject.map { _ in return ()}.asObservable())
        transformPushRepresentProject(input: input.representProjectSelected)
    }
    
    func transformGetMembers(input: Observable<Void>) {
        let getmemberResult = Observable.merge(input, refresh)
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
    
    func transformUserExple(input: PublishRelay<UserExpelProps>) {
        input
            .withUnretained(self)
            .subscribe(onNext: { this, props in
                this.expelSuccess.accept(())
                this.refresh.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
