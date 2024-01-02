//
//  SplashViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/06.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa

final class SplashViewController: ViewController {

    private let viewModel: SplashViewModel

    private let mainView: SplashMainView = SplashMainView()

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .teamOne.mainColor
    }

    override func bind() {
        let input = SplashViewModel.Input(
            viewDidAppear: rx.viewWillAppear.map { _ in }.asObservable()
        )

        let output = viewModel.transform(input: input)
    }

}
