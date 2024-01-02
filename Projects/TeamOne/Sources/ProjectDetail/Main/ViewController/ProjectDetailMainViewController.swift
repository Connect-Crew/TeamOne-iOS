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

final class ProjectDetailMainViewController: ViewController {

    private let viewModel: ProjectDetailMainViewModel

    let viewNavigation = ProjectDetailNavigation()

    lazy var categoryView = DetailMainCategoryView()

    let introduceVC: ProjectDetailPageSubIntroduceViewController

    let vc2 = UIViewController().then {
        $0.view.backgroundColor = .red
    }

    let vc3 = UIViewController().then {
        $0.view.backgroundColor = .black
    }

    lazy var pageViewController = BasePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initPage()
    }

    // MARK: - Inits

    init(viewModel: ProjectDetailMainViewModel,
         introduceVC: ProjectDetailPageSubIntroduceViewController) {
        self.viewModel = viewModel
        self.introduceVC = introduceVC
        super.init(nibName: nil, bundle: nil)
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

    func initPage() {
        pageViewController.addVC(addList: [introduceVC, vc2, vc3])
    }

    override func bind() {
        let input = ProjectDetailMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in return }.asObservable(),
            backButtonTap: viewNavigation.buttonNavigationLeft.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
        )

        categoryView.categorySelectedSubject
            .bind(to: pageViewController.rx.goToPage)
            .disposed(by: disposeBag)

        pageViewController.selectedPageSubject
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.categoryView.selectCategory(index: $0)
            })
            .disposed(by: disposeBag)

        let output = viewModel.transform(input: input)
    }

    deinit {
        print("!!!!!!!!!!!\(self)::::")
        print("Deinit")
        print("!!!!!!!!!!!!")
    }
}
