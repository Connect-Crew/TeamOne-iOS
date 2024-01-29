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

    let mainView = IntroduceMainView(frame: .zero)

    // MARK: - LifeCycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Inits

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(output: ProjectDetailMainViewModel.Output) {
     
        bindProject(output: output)
        mainView.viewBottom.bind(output: output)
        mainView.viewRecuritStatus.bind(output: output)
    }

    private func bindProject(output: ProjectDetailMainViewModel.Output) {
        let project = output.project
            .compactMap { $0 }

        project
            .map { return (region: $0.region, isOnline: $0.isOnline) }
            .drive(onNext: { [weak self] args in
                if args.isOnline == .online {
                    self?.mainView.labelLocaion.text = "온라인"
                } else if args.isOnline == .onOffline {
                    self?.mainView.labelLocaion.text = "온라인 + \(args.region)"
                } else {
                    self?.mainView.labelLocaion.text = args.region
                }
            })
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
            .drive(onNext: { [weak self] array in
                self?.mainView.imageSlider.path = array
            })
            .disposed(by: disposeBag)
        
        // 내 프로젝트가 아니면서, 지원이 마감되었을 때 처리
        Observable.combineLatest(
            output.project.map { $0.isAppliable }.asObservable(),
            output.isMyProject.asObservable()
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
