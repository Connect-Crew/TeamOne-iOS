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
import SDWebImage

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
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            manageButtonTap: mainView.viewBottom.buttonProjectManagement.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)

        bindProject(output: output)
        
        mainView.viewBottom.bind(output: output)
        mainView.viewRecuritStatus.bind(output: output)
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
        
        project
            .map { $0.banners }
            .filter { !$0.isEmpty }
            .drive(onNext: { [weak self] array in
                UIImageView.pathToImage(path: array) { images in
                    self?.mainView.imageSlider.configure(with: images)
                }
            })
            .disposed(by: disposeBag)
        
        // 내 프로젝트가 아니면서, 지원이 마감되었을 때 처리
        Observable.combineLatest(
            output.project.map { $0?.isAppliable }.asObservable(),
            output.isMyproject.asObservable()
        )
        .map { result in
            let isAppliable = result.0
            let isMyproject = result.1
            
            if isMyproject == false && isAppliable == false {
                return true
            }
            
            return false
        }
        .filter { $0 == true }
        .subscribe(on: MainScheduler.instance)
        .withUnretained(self)
        .subscribe(onNext: { this, _ in
            this.mainView.viewBottom.buttonApply.isEnabled = false
        })
        .disposed(by: disposeBag)
    }
}
