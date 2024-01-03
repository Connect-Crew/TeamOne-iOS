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
        pageViewController.addVC(addList: [introduceVC, vc2, vc3])
    }
    
    // MARK: - Subjects
    
    let dropDownResultSubject = PublishSubject<String>()
    let reportButtonTabSubject = PublishSubject<Void>()
    
    // 신고하기를 누르면 해당 서브젝트로 전달
    let reportedContentSubject = PublishSubject<String>()
    
    // MARK: - Bind
    
    override func bind() {
        let input = ProjectDetailMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in return }.asObservable(),
            backButtonTap: viewNavigation.buttonNavigationLeft.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)
        
        bindPage()
        bindRightBarButton(output: output)
        bindDropDown()
        bindReport()
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
            .map { _ in
                let alert = AlertView_Title_TextView_Item(
                    title: "이 프로젝트를 신고하시겠습니까?", 
                    placeHolder: "신고 사유를 최대 100자 까지 작성해주세요",
                    okButtonTitle: "신고하기",
                    maxTextCount: 100,
                    callBack: { [weak self] bool, content in
                        if bool == true {
                            self?.reportedContentSubject.onNext(content)
                        }
                    }
                )
                
                return alert
            }
            .withUnretained(self)
            .subscribe(onNext: { this, alert in
                self.presentAlert_Title_TextView(
                    source: this,
                    alert: alert
                )
            })
            .disposed(by: disposeBag)
        
        // TODO: - 여기부터 신고기능 이어하기.
        
        reportedContentSubject
            .subscribe(onNext: {
                print("!!!!!!!!!!!\(self)::::")
                print($0)
                print("!!!!!!!!!!!!")
            })
    }
}
