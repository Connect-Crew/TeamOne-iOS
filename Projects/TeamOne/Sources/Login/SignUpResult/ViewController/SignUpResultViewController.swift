//
//  SignUpResultViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class SignUpResultViewController: ViewController {

    private let viewModel: SignUpResultViewModel

    private let mainView = SignUpResultMainView()

    // MARK: - LifeCycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - Inits

    init(viewModel: SignUpResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind() {
        let input = SignUpResultViewModel.Input()

        let output = viewModel.transform(input: input)
    }
}
