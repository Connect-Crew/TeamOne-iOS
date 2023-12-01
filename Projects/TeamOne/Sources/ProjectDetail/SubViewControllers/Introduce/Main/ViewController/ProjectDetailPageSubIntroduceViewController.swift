//
//  ProjectDetailPageSubIntroduceViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class ProjectDetailPageSubIntroduceViewController: ViewController {

    private let viewModel: ProjectDetailPageSubIntroduceViewModel

    private let mainView = IntroduceMainView(frame: .zero)

    // MARK: - LifeCycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Inits

    init(viewModel: ProjectDetailPageSubIntroduceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind() {
        let input = ProjectDetailPageSubIntroduceViewModel.Input(
            likeButtonTap: mainView.viewBottom.buttonLike.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            applyButtonTap: mainView.viewBottom.buttonApply.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)

        bindProject(output: output)

        mainView.viewBottom.buttonApply.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.showBottomSheet()
            })
            .disposed(by: disposeBag)
    }

    func bindProject(output: ProjectDetailPageSubIntroduceViewModel.Output) {
        let project = output.project
            .compactMap { $0 }

        project
            .map { $0.region }
            .drive(mainView.labelLocaion.rx.text)
            .disposed(by: disposeBag)

        project
            .map { $0.createdAt }
            .map { $0.toRelativeDateString() }
            .drive(mainView.labelTime.rx.text)
            .disposed(by: disposeBag)

        project
            .map { $0.title }
            .drive(mainView.labelTitle.rx.text)
            .disposed(by: disposeBag)

        project
            .map { $0.leader }
            .drive(mainView.viewIntroduceLeader.rx.leader)
            .disposed(by: disposeBag)

        project
            .map { $0.hashTags }
            .drive(onNext: { [weak self] in
                self?.mainView.initHashTag(hashTags: $0)
            })
            .disposed(by: disposeBag)

        project
            .map { $0.recruitStatus }
            .drive(mainView.viewRecuritStatus.rx.status)
            .disposed(by: disposeBag)

        project
            .map { $0.introduction }
            .drive(mainView.textView.rx.text)
            .disposed(by: disposeBag)

        project
            .map { $0.skills }
            .drive(mainView.viewTechStack.rx.list)
            .disposed(by: disposeBag)

        project
            .map { $0.isAppliable }
            .drive(mainView.viewBottom.buttonApply.rx.isEnabled)
            .disposed(by: disposeBag)

        project
            .map { $0.myFavorite }
            .drive(mainView.viewBottom.buttonLike.rx.isLiked)
            .disposed(by: disposeBag)

        project
            .map { $0.favorite }
            .drive(mainView.viewBottom.buttonLike.rx.likedCount)
            .disposed(by: disposeBag)
    }

    func showBottomSheet() {
        
    }
}

