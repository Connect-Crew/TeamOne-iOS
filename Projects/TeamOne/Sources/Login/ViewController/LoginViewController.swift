//
//  LoginViewController.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core

import RxSwift
import RxCocoa
import SnapKit
import Then

final class LoginViewController: ViewController {

    // MARK: - Properties

    private let viewModel: LoginViewModel

    private let mainView = LoginView()

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

//        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Inits

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

}

