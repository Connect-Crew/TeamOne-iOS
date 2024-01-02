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

final class ProjectCreateMainViewController: ViewController {

    private let viewModel: ProjectCreateMainViewModel

    private let mainView = ProjectCreateMainView()

    lazy var pageViewController = BasePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {

        $0.removeSwipeGesture()
    }

    let nameVC = ProjectCreateNameViewController()

    let stateRegionVC = ProjectSetStateRegionViewController()

    let purposeCareerVC = ProjectSetPurposeCareerViewController()

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
        pageViewController.addVC(addList: [nameVC, stateRegionVC, purposeCareerVC, categoryVC, postVC])
    }

    override func bind() {
        let input = ProjectCreateMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in return ()}.asObservable(),
            closeButtonTap: mainView.buttonClose.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            nextButtonTap: Observable.merge(
                nameVC.buttonNext.rx.tap.map { _ in return ()},
                stateRegionVC.buttonNext.rx.tap.map { _ in return ()},
                purposeCareerVC.buttonNext.rx.tap.map { _ in return ()},
                categoryVC.buttonNext.rx.tap.map { _ in return () }
            ).throttle(.seconds(1), latest: true, scheduler: MainScheduler.asyncInstance),
            projectName: nameVC.textFieldName.rx.text.orEmpty.asObservable(),
            beforeButtonTap: Observable.merge(
                stateRegionVC.buttonBefore.rx.tap.map { _ in return () },
                purposeCareerVC.buttonBefore.rx.tap.map { _ in return () },
                categoryVC.buttonBefore.rx.tap.map { _ in return () },
                postVC.buttonBefore.rx.tap.map { _ in () }
            ).throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
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
            selectLocation: stateRegionVC.locaionListStackView.selectLocationSubject,

            purposeStartUpTap: purposeCareerVC.buttonPurposeStartup.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            purposePortfolioTap: purposeCareerVC.buttonPurposePortfolio.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            noRequiredExperienceTap: purposeCareerVC.buttonnoExperienceRequiredCheckBox.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            selectedMinCareer:
                purposeCareerVC.minCareerSubject,
            selectedMaxCareer: purposeCareerVC.maxCareerSubject,
            categoryTap: categoryVC.categoryTapSubject,
            
            selectedImage: postVC.selectedImage,
            deleteImageTap: postVC.deleteImage,
            recruitTeamOne: postVC.viewSetPart.rxRecruits.map { $0.map { Recurit(part: $0.partSub, comment: $0.comment, max: $0.max)} },

            introduce: postVC.textViewIntroduce.rx.text.orEmpty.asObservable(),

            leaderPart: postVC.seledtedLeaderMajorSubClass.map { $0.0 },

            selectedSkillTap: postVC.viewSelectSkill.selectedSkillSubject,
            deleteSkillTap: postVC.viewSelectedStack.deleteButtonTapSubject,
            createButtonTap: postVC.buttonCreateProject.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)

        bindPage(output: output)
        bindNavigation(output: output)
        bindStateRegionVC(output: output)

        stateRegionVC.bind(output: output)
        purposeCareerVC.bind(output: output)
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

    func bindNavigation(output: ProjectCreateMainViewModel.Output) {
        output.cancleAlert
            .subscribe(onNext: { [weak self] alert in
                self?.presentResultAlertView_Image_Title_Content(source: self, alert: alert)
            })
            .disposed(by: disposeBag)
    }

    func bindStateRegionVC(output: ProjectCreateMainViewModel.Output) {
        output.locationList .drive(stateRegionVC.locaionListStackView.rx.regions)
            .disposed(by: disposeBag)
    }

    deinit {
        print("!!!!!!!!!!!\(self)::::")
        print("Deinit")
        print("!!!!!!!!!!!!")
    }
}
