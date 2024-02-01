//
//  SettingViewController.swift
//  TeamOne
//
//  Created by 강현준 on 1/30/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit
import Domain

final class SettingViewController: ViewController {
    
    lazy var logoutAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "로그아웃 하시겠습니까?",
        content: "",
        okButtonTitle: "확인",
        availableCancle: true,
        resultSubject: logoutResult
    )
    
    private let viewModel: SettingViewModel
    
    private let mainView = SettingMainView()
    
    private let logoutResult = PublishSubject<Bool>()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Inits
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = SettingViewModel.Input(
            viewDidLoad: rx.viewWillAppear.take(1).map { _ in () }.asObservable(),
            backButtonTap: mainView.backButtonTap,
            cellDidSelect: mainView.tableView.rx.itemSelected
                .withUnretained(self)
                .map { this, indexPath -> SettingCellType? in
                    return this.mainView.dataSource?.itemIdentifier(for: indexPath)
                }
                .compactMap { $0 },
            logoutTap: logoutResult.filter { $0 == true }.map { _ in () }
        )
        
        let output = viewModel.transform(input: input)
        
        mainView.bind(output: output)
        
        let itemSelected = mainView.tableView.rx.itemSelected
            .withUnretained(self)
            .map { this, indexPath in
                return this.mainView.dataSource?.itemIdentifier(for: indexPath)
            }
            .compactMap { $0 }
        
        bindAppSetting(itemSelectd: itemSelected)
        
    }
    
    private func bindAppSetting(itemSelectd: Observable<SettingCellType>) {
    
        // MARK: - Singout
        itemSelectd
            .filter { $0 == .logout }
            .withUnretained(self)
            .map { this, _ in
                this.logoutAlert
            }
            .withUnretained(self)
            .bind(onNext: { this, alert in
                this.presentResultAlertView_Image_Title_Content(source: this, alert: alert, darkbackground: true)
            })
            .disposed(by: disposeBag)
    }
}

