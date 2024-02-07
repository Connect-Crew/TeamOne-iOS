//
//  DropoutViewController.swift
//  TeamOne
//
//  Created by 강창혁 on 2/7/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class DropoutViewController: ViewController {
    
    private let viewModel: DropoutViewModel
    
    private let mainView = DropoutMainView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    // MARK: - Inits
    
    init(viewModel: DropoutViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = DropoutViewModel.Input(
            tapBack: mainView.backButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input: input)
    }
    
}
