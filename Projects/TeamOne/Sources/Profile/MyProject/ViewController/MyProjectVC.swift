//
//  MyProjectVC.swift
//  TeamOne
//
//  Created by Junyoung on 2/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import UIKit
import Core
import RxSwift
import RxCocoa
import Then

final class MyProjectVC: ViewController {
    
    private let viewModel: MyProjectViewModel
    
    private let mainView = MyProjectMainView()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Inits
    
    init(viewModel: MyProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = MyProjectViewModel.Input(
            tapBack: mainView.backButton.rx.tap.asObservable(),
            viewWillAppear: rx.viewWillAppear.map { _ in Void() }.asObservable()
        )
        
        let output = viewModel.transform(input: input)
    }
}
