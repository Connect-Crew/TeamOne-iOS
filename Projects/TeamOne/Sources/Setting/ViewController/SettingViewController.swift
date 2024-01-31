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

final class SettingViewController: ViewController {
    
    lazy var signOutAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "로그아웃 하시겠습니까?",
        content: "",
        okButtonTitle: "확인",
        availableCancle: true,
        resultSubject: signOutAlertResult
    )
    
    private let viewModel: SettingViewModel
    
    private let mainView = SettingMainView()
    
    private let signOutAlertResult = PublishSubject<Bool>()
    
    private let appSettingTap = PublishRelay<SettingType.AppSettingType>()
    
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
            viewDidLoad: rx.viewWillAppear.map { _ in () }.asObservable(),
            backButtonTap: mainView.backButtonTap,
            appSettingTap: appSettingTap,
            notificationSettingTap: mainView.notificationSettingTap
        )
        
        let output = viewModel.transform(input: input)
        
        mainView.bind(output: output)
        bindAppSetting()
    }
    
    private func bindAppSetting() {
        
        // MARK: - Singout
        mainView.appSettingTap
            .filter { $0 == .signOut}
            .withUnretained(self)
            .map { this, _ in
                this.signOutAlert
            }
            .withUnretained(self)
            .bind(onNext: { this, alert in
                this.presentResultAlertView_Image_Title_Content(source: this, alert: alert, darkbackground: true)
            })
            .disposed(by: disposeBag)
        
        signOutAlertResult
            .filter { $0 == true}
            .map { _ in return .signOut }
            .bind(to: appSettingTap)
            .disposed(by: disposeBag)
    }
}

