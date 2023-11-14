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

final class LoginMainViewController: ViewController {
    
    // MARK: - Properties
    
    private let viewModel: LoginMainViewModel
    private let mainView = LoginMainView()
   
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Inits
    
    init(viewModel: LoginMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind

    override func bind() {
        let input = LoginMainViewModel.Input(
            kakaoLoginTap: mainView.kakaoButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            googleLoginTap: mainView.googleButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            appleLoginTap: mainView.appleButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
        )

        

        let output = viewModel.transform(input: input)

    }
} 
