//
//  ProjectDetailMainViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit
import Domain
import Inject

final class ProjectDetailMainViewController: ViewController {

    private let viewModel: ProjectDetailMainViewModel

    let viewNavigation = ProjectDetailNavigation()

    lazy var categoryView = DetailMainCategoryView()
    
    // MARK: - DropDown
    
    let dropDownMenus: [DropDownMenu] = [
        DropDownMenu(title: "신고하기", titleColor: .teamOne.point, titleFont: .button1)
    ]
    
    lazy var dropDown = DropDown(
        menus: dropDownMenus,
        maxShowCount: 1, 
        cellHeight: 35,
        textAlignment: .left
    )
    
    // MARK: - PageViewControllers

    let introduceVC = ProjectDetailPageSubIntroduceViewController()

    let memberListVC = MemberListViewController()

    let chatVC = ChatViewController()

    lazy var pageViewController = BasePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initPage()
    }

    // MARK: - Inits

    init(viewModel: ProjectDetailMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupDropDown()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        self.view.addSubview(viewNavigation)

        viewNavigation.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        self.view.addSubview(categoryView)

        categoryView.snp.makeConstraints {
            $0.top.equalTo(viewNavigation.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        addChild(pageViewController)

        self.view.addSubview(pageViewController.view)

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupDropDown() {
        
        self.view.addSubview(dropDown)
        
        dropDown.snp.makeConstraints {
            $0.top.equalTo(viewNavigation.buttonNavigationRight.snp.bottom)
            $0.trailing.equalTo(viewNavigation.buttonNavigationRight)
        }
        
        viewNavigation.buttonNavigationRight.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        
        dropDown.completion = { [weak self] result in
            guard let self = self else { return }
            
            self.dropDownResultSubject.onNext(result)
        }
    }
    
    @objc private func buttonTapped() {
        dropDown.tableView.isHidden.toggle()
    }

    func initPage() {
        pageViewController.addVC(addList: [introduceVC, memberListVC, chatVC])
    }
    
    // MARK: - Subjects
    
    let dropDownResultSubject = PublishSubject<String>()
    let reportButtonTabSubject = PublishSubject<Void>()
    
    /// 프로젝트 신고하기
    let reportedContentSubject = PublishSubject<String>()
    /// 유저 내보내기
    let expelSuccess = PublishRelay<Void>()
    let expelFailure = PublishRelay<Error>()
    let expelProps = PublishRelay<(projectId: Int, userId: Int, reasons: [User_ExpelReason])>()
    
    let modifyTap = PublishRelay<Void>()
    let manageApplicantsTap = PublishRelay<Void>()
    let deleteTap = PublishRelay<Void>()
    let completeTap = PublishRelay<Void>()
    
    let presentDeleteAlert = PublishRelay<Void>()
    let presentCompleteAlert = PublishRelay<Void>()
    
    // MARK: - Bind
    
    override func bind() {
        let input = ProjectDetailMainViewModel.Input(
            viewDidLoad: rx.viewWillAppear.take(1).map { _ in return ()}.asObservable(),
            viewWillAppear: rx.viewWillAppear.map { _ in return }.asObservable(),
            backButtonTap: viewNavigation.buttonNavigationLeft.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance), 
            reportContent: reportedContentSubject,
            profileSelected: memberListVC.profileSelected
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            representProjectSelected: memberListVC.representProjectSelected
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            likeButtonTap: introduceVC.mainView.viewBottom.buttonLike.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            applyButtonTap: introduceVC.mainView.viewBottom.buttonApply.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            expelProps: expelProps,
            modifyButtonTap: modifyTap,
            manageApplicantsButtonTap: manageApplicantsTap,
            deleteButtonTap: deleteTap,
            completeButtonTap: completeTap
        )

        let output = viewModel.transform(input: input)
        
        bindPage()
        bindRightBarButton(output: output)
        bindDropDown()
        bindReport()
        bindAlert(output: output)
        bindExpel(output: output)
        bindManage(output: output)
        
        introduceVC.bind(output: output)
        memberListVC.bind(output: output)
    }
    
    func bindPage() {
        categoryView.categorySelectedSubject
            .bind(to: pageViewController.rx.goToPage)
            .disposed(by: disposeBag)

        pageViewController.selectedPageSubject
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.categoryView.selectCategory(index: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func bindRightBarButton(output: ProjectDetailMainViewModel.Output) {
        output.isMyProject
            .drive(onNext: { [weak self] isMine in
                self?.viewNavigation.buttonNavigationRight.isHidden = isMine
            })
            .disposed(by: disposeBag)
    }
    
    func bindDropDown() {
        dropDownResultSubject
            .filter { $0 == "신고하기" }
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.reportButtonTabSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func bindReport() {
        reportButtonTabSubject
            .withUnretained(self)
            .map { this, _ in
                let alert = AlertView_Title_TextView_Item(
                    title: "이 프로젝트를 신고하시겠습니까?", 
                    placeHolder: "신고 사유를 최대 100자 까지 작성해주세요",
                    okButtonTitle: "신고하기",
                    maxTextCount: 100,
                    callBack: { bool, content in
                        if bool == true {
                            this.reportedContentSubject.onNext(content)
                        }
                    }
                )
                
                return alert
            }
            .withUnretained(self)
            .subscribe(onNext: { this, alert in
                this.presentAlert_Title_TextView(
                    source: this,
                    alert: alert
                )
            })
            .disposed(by: disposeBag)
    }
    
    func bindAlert(output: ProjectDetailMainViewModel.Output) {
        // 에러 알럿 바인딩
        output.error
            .bind(to: rx.presentErrorAlert)
            .disposed(by: disposeBag)
        
        output.reportResult
            .map { _ in
                return ResultAlertView_Image_Title_Content_Alert(
                    image: .complete,
                    title: "신고가 완료되었습니다.",
                    content: "소중한 의견 감사합니다.", 
                    okButtonTitle: "신고하기",
                    availableCancle: false
                )
            }
            .withUnretained(self)
            .emit(onNext: { this, alert in
                this.presentResultAlertView_Image_Title_Content(
                    source: this,
                    alert: alert
                )
            })
            .disposed(by: disposeBag)
        
        // MARK: - 수정하기, 삭제하기 alert
        
        let deleteAlertResult = PublishSubject<Bool>()
        
        presentDeleteAlert
            .map { _ in
                return ResultAlertView_Image_Title_Content_Alert(
                    image: .warnning,
                    title: "프로젝트를 삭제하시겠습니까?",
                    content: "삭제 전 한번 더 고민해보시기 바랍니다", 
                    okButtonTitle: "삭제",
                    availableCancle: true,
                    resultSubject: deleteAlertResult
                )
            }
            .withUnretained(self)
            .bind(onNext: { this, alert in
                this.presentResultAlertView_Image_Title_Content(source: this, alert: alert)
            })
            .disposed(by: disposeBag)
        
        deleteAlertResult
            .filter { $0 == true }
            .map { _ in return () }
            .bind(to: deleteTap)
            .disposed(by: disposeBag)
        
        let completeAlertResult = PublishSubject<Bool>()
        
        presentCompleteAlert
            .map { _ in
                return ResultAlertView_Image_Title_Content_Alert(
                    image: .completeProject,
                    title: "프로젝트를 완수하시겠습니까?",
                    content: "프로젝트를 마무리하느라 수고하셨습니다!", 
                    okButtonTitle: "종료",
                    availableCancle: true,
                    resultSubject: completeAlertResult
                )
            }
            .withUnretained(self)
            .bind(onNext: { this, alert in
                this.presentResultAlertView_Image_Title_Content(source: this, alert: alert)
            })
            .disposed(by: disposeBag)
        
        completeAlertResult
            .filter { $0 == true }
            .map { _ in return () }
            .bind(to: completeTap)
            .disposed(by: disposeBag)
            
    }
    
    // MARK: - 유저 내보내기
    
    func bindExpel(output: ProjectDetailMainViewModel.Output) {
        
        output.expelSuccess
            .bind(to: expelSuccess)
            .disposed(by: disposeBag)
        
        output.expelFailure
            .bind(to: expelFailure)
            .disposed(by: disposeBag)
        
        memberListVC.expelMemberSelected
            .withLatestFrom(output.project) { member, project in
                return (member, project)
            }
            .withUnretained(self)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { this, content in
                
                let member = content.0
                let project = content.1
                
                let expelVC = Inject.ViewControllerHost(UserExpelViewController(
                    project: project,
                    target: member,
                    expelSuccess: this.expelSuccess,
                    expelFailure: this.expelFailure,
                    expelProps: this.expelProps
                ))
                
                expelVC.modalPresentationStyle = .overFullScreen
                this.present(expelVC, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    func bindManage(output: ProjectDetailMainViewModel.Output) {
        
        let manageTap = introduceVC.mainView.viewBottom.buttonProjectManagement.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
        
        manageTap
            .withUnretained(self)
            .bind(onNext: { this, _ in
                
                let manageProjectVC = ManageProjectMainVC()

                manageProjectVC.mainView.bottomSheet.bind(
                    isDeletable: output.isDeletable,
                    isCompletable: output.isCompletable
                )
                
                manageProjectVC.modifySubject
                    .bind(to: this.modifyTap)
                    .disposed(by: manageProjectVC.disposeBag)
                
                manageProjectVC.manageApplicantsSubject
                    .bind(to: this.manageApplicantsTap)
                    .disposed(by: manageProjectVC.disposeBag)
                
                manageProjectVC.deleteButtonTap
                    .bind(to: this.presentDeleteAlert)
                    .disposed(by: manageProjectVC.disposeBag)
                
                manageProjectVC.completeButtonTap
                    .bind(to: this.presentCompleteAlert)
                    .disposed(by: manageProjectVC.disposeBag)
                
                manageProjectVC.modalPresentationStyle = .overFullScreen
                
                this.present(manageProjectVC, animated: false)
                
            })
            .disposed(by: disposeBag)
        
        
    }
}
