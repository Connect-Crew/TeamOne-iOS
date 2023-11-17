//
//  SetNickNameViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SetNickNameViewController: ViewController {

    // MARK: - Properties

    private let viewModel: SetNickNameViewModel

    private let mainView = SetNickNameMainView()

    // MARK: - LifeCycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Inits

    init(viewModel: SetNickNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bind

    override func bind() {
        let input = SetNickNameViewModel.Input(
            nickname: mainView.textFieldNickName.rx.text.orEmpty.asObservable(),
            clearButtonTapped: mainView.textFieldNickName.button.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            registeredButtonTapped: mainView.buttonNext.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            backButtonTapped: mainView.buttonNavigationLeft.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            closeButtonTapped: mainView.buttonNavigationRight.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)

        output.isEnabled
            .drive(mainView.buttonNext.rx.isEnabled)
            .disposed(by: disposeBag)

        output.errorText
            .drive(mainView.labelExplane.rx.text)
            .disposed(by: disposeBag)
    }
}
