//
//  ApplyBottomSheetViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit

final class ApplyViewController: ViewController {

    private let viewModel: ApplyViewModel

    private let mainView = ApplyMainView(frame: .zero)

    // MARK: - LifeCycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.mainView.animateBottomSheet()
        self.mainView.writeApplicationView.adjustForKeyboard(disposeBag: disposeBag)
    }

    // MARK: - Inits

    init(viewModel: ApplyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind() {
        let input = ApplyViewModel.Input(
            close: mainView.closeSubject.asObservable(),
            applyPartTap: mainView.applyBottomSheet.selectedPartSubject
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            applicationText: mainView.writeApplicationView.textView.rxTextObservable,
            applyButtonTap: mainView.writeApplicationView.applyButton.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
        )

        let output = viewModel.transform(input: input)

        let project = output.project
            .compactMap { $0 }

        project
            .map { $0.recruitStatus }
            .drive(mainView.applyBottomSheet.rx.status)
            .disposed(by: disposeBag)

        output
            .showWriteApplication
            .subscribe(onNext: { [weak self] recruitStatus in
                self?.mainView.dismissBottomSheet(isEnd: false, completion: {
                    self?.mainView.showWriteApplicationView(status: recruitStatus)
                })
            })
            .disposed(by: disposeBag)

        output
            .showResult
            .withUnretained(self)
            .emit(onNext: { viewController, result in
                viewController.mainView.hideWriteApplicationView()
                viewController.mainView.showResult()
            })
            .disposed(by: disposeBag)
        
        output
            .showError
            .withUnretained(self)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { this, alert in
                
                this.mainView.hideWriteApplicationView()
                this.presentResultAlertView_Image_Title_Content(
                    source: this,
                    alert: alert
                )
                
                alert.resultSubject?
                    .map { _ in () }
                    .bind(to: this.mainView.closeSubject)
                    .disposed(by: this.disposeBag)
            })
            .disposed(by: disposeBag)

    }
}
