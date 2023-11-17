//
//  TosViewController.swift
//  TeamOne
//
//  Created by 임재현 on 2023/11/01.
//  Copyright © 2023 TeamOne. All rights reserved.
//
import Foundation
import UIKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class TosViewController: ViewController {

    // MARK: - Properties
    
    private let viewModel: TosViewModel
    
    private let mainView = TosView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - Inits
    
    init(viewModel: TosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind

    override func bind() {
        let input = TosViewModel.Input(
            allSelected: mainView.buttonAllCheckBox.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            serviceTermSelected: mainView.buttonUserServiceTermsCheckBox.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            personalInfoPolycy: mainView.buttonUserPersonalInfoPolicyCheckBox.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            nextButtonTap: mainView.buttonNext.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            backButtonTap: mainView.leftBackButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            closeButtonTap: mainView.buttonClose.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)

        output.allSelected
            .drive(mainView.buttonAllCheckBox.rx.isSelected)
            .disposed(by: disposeBag)

        output.serviceTermSelected
            .drive(mainView.buttonUserServiceTermsCheckBox.rx.isSelected)
            .disposed(by: disposeBag)

        output.personalInfoPolycy
            .drive(mainView.buttonUserPersonalInfoPolicyCheckBox.rx.isSelected)
            .disposed(by: disposeBag)

        output.allSelected
            .drive(mainView.buttonNext.rx.isEnabled)
            .disposed(by: disposeBag)

    }
    
}



