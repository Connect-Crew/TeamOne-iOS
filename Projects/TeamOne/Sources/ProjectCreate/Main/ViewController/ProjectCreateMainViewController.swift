//
//  ProjectCreateMainViewController.swift
//  TeamOne
//
//  Created by 강현준 on 12/1/23.
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

final class ProjectCreateMainViewController: ViewController {
    
    lazy var createAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "프로젝트를 생성하시겠습니까?",
        content: "확인을 누르시면 프로젝트가 생성됩니다.",
        availableCancle: true,
        resultSubject: self.createSubject
    )
    
    lazy var cancleAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "생성을 중단하시겠습니까?",
        content: "확인을 누르시면 모든 내용이 삭제됩니다.",
        availableCancle: true,
        resultSubject: self.closeSubject
    )

    private let viewModel: ProjectCreateMainViewModel

    private let mainView = ProjectCreateMainView()

    lazy var pageViewController = BasePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {

        $0.removeSwipeGesture()
    }

    let nameVC = ProjectCreateNameViewController()

    let stateRegionVC = ProjectSetStateRegionViewController()

    let goalCareerVC = ProjectSetGoalCareerViewController()

    let categoryVC = ProjectSetCategoryViewController()

    let postVC = ProjectSetPostViewController()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Inits

    init(viewModel: ProjectCreateMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        initPages()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {

        view.addSubview(mainView)

        mainView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        addChild(pageViewController)

        self.view.addSubview(pageViewController.view)

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(mainView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func initPages() {
        pageViewController.addVC(addList: [nameVC, stateRegionVC, goalCareerVC, categoryVC, postVC])
    }

    override func bind() {
        let input = ProjectCreateMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in return ()}.asObservable(),
            closeButtonTap: closeSubject.filter { $0 == true }.map { _ in return () },
            nextButtonTap: Observable.merge(
                nameVC.buttonNext.rx.tap.map { _ in return ()},
                stateRegionVC.buttonNext.rx.tap.map { _ in return ()},
                goalCareerVC.buttonNext.rx.tap.map { _ in return ()},
                categoryVC.buttonNext.rx.tap.map { _ in return () }
            ).throttle(.seconds(1), latest: true, scheduler: MainScheduler.asyncInstance),
            beforeButtonTap: Observable.merge(
                stateRegionVC.buttonBefore.rx.tap.map { _ in return () },
                goalCareerVC.buttonBefore.rx.tap.map { _ in return () },
                categoryVC.buttonBefore.rx.tap.map { _ in return () },
                postVC.buttonBefore.rx.tap.map { _ in () }
            ).throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance), 
            title: nameVC.textFieldName.rx.text.orEmpty.asObservable()
            ,
            stateBeforeTap: stateRegionVC.buttonStateBefore.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            stateRunningTap: stateRegionVC.buttonStateRunning.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            onlineTap: stateRegionVC.buttonRegionOnline.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            onOfflineTap: stateRegionVC.buttonRegionOnOffline.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            offlineTap: stateRegionVC.buttonRegionOffline.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            selectedRegion: stateRegionVC.locaionListStackView.selectLocationSubject,

            goalStartUpTap: goalCareerVC.buttonPurposeStartup.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            goalPortfolioTap: goalCareerVC.buttonPurposePortfolio.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            noRequiredExperienceTap: goalCareerVC.buttonnoExperienceRequiredCheckBox.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            selectedMinCareer:
                goalCareerVC.minCareerSubject,
            selectedMaxCareer: goalCareerVC.maxCareerSubject,
            categoryTap: categoryVC.categoryTapSubject,
            
            selectedImage: postVC.selectedImage,
            deleteImageTap: postVC.deleteImage,
            
            addRecruit: postVC.addedRecruit,
            minusRecruit: postVC.minusRecruit,
            plusRecruit: postVC.plusRecruit,
            deleteRecruit: postVC.deleteRecruit,
            changeCommentRecruit: postVC.changeCommentRecruit,

            introduce: postVC.textViewIntroduce.rxTextObservable,
            
            leaderPart: postVC.selectedLeaderPart,

            selectedSkillTap: postVC.viewSelectSkill.selectedSkillSubject,
            deleteSkillTap: postVC.viewSelectedStack.deleteButtonTapSubject,
            createButtonTap: createSubject.filter { $0 == true }
                .map { _ in return () }
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            errorOKTap: errorSubject
        )

        let output = viewModel.transform(input: input)

        bindPage(output: output)
        bindNavigation(output: output)
        bindModify(output: output)

        nameVC.bind(output: output)
        stateRegionVC.bind(output: output)
        goalCareerVC.bind(output: output)
        categoryVC.bind(output: output)
        postVC.bind(output: output)
    }

    func bindPage(output: ProjectCreateMainViewModel.Output) {
        output.currentPage
            .drive(onNext: { [weak self] in
                self?.pageViewController.goToPage($0)
                self?.mainView.stepIndicatorView.currentStep = $0 + 1
            })
            .disposed(by: disposeBag)
    }
    
    let closeSubject = PublishSubject<Bool>()
    let createSubject = PublishSubject<Bool>()
    let errorSubject = PublishSubject<Void>()

    func bindNavigation(output: ProjectCreateMainViewModel.Output) {
        
        mainView.buttonClose.rx.tap
            .withUnretained(self)
            .map { this, _ in
                return this.cancleAlert
            }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] alert in
                guard let self = self else { return }
                
                self.presentResultAlertView_Image_Title_Content(
                    source: self,
                    alert: alert
                )
            })
            .disposed(by: disposeBag)
        
        postVC.buttonCreateProject.rx.tap
            .withUnretained(self)
            .map { this, _ in
                return this.createAlert
            }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] alert in
                guard let self = self else { return }
                
                self.presentResultAlertView_Image_Title_Content(
                    source: self,
                    alert: alert
                )
            })
            .disposed(by: disposeBag)
        
        output.error
            .subscribe(onNext: { [weak self] error in
                self?.presentErrorAlert(
                    error: error,
                    finishSubject: self?.errorSubject
                )
            })
            .disposed(by: disposeBag)
    }
    
    func bindModify(output: ProjectCreateMainViewModel.Output) {
        
        output.isModify
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.createAlert.title = "프로젝트 수정을 완료하시겠습니까?"
                this.createAlert.content = "확잉늘 누르시면 프로젝트가 수정됩니다."
                
                this.cancleAlert.title = "수정을 중단하시겠습니까?"
                this.cancleAlert.content = "확인을 누르시면 모든 내용이 삭제됩니다."
            })
            .disposed(by: disposeBag)
        
    }
}
