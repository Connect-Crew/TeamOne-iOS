//
//  SignUpCompleteViewController.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import Core

import RxSwift
import RxCocoa
import SnapKit
import Then

final class SignUpCompleteViewController: ViewController {

    // MARK: - Properties

    private let viewModel: SignUpCompleteViewModel
    private let mainView = SignUpCompleteView()
   // let buttonTapObservable2 = PublishSubject<Void>()
    // MARK: - LifeCycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainView.startButton.rx.tap
                   .bind(to: mainView.startButtonAction)
                   .disposed(by: disposeBag)

               mainView.startButtonAction
                   .subscribe(onNext: { [weak self] in
                       self?.startButtonTapped()

                   })
                   .disposed(by: disposeBag)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Inits

    init(viewModel: SignUpCompleteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    @objc func startButtonTapped() {
           print("Kakao button tapped")
          let viewcontroller = HomeViewController(viewModel: HomeViewModel())
        self.navigationController?.pushViewController(viewcontroller, animated: true)
       }
    }

