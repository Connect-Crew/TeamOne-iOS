//
//  ManageProjectMainVC.swift
//  TeamOne
//
//  Created by 강현준 on 1/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import Domain
import DSKit

final class ManageProjectMainVC: ViewController {
    
    private let viewModel: ManageProjectMainViewModel
    
    private let mainView = ManageProjectMainView(frame: .zero)
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    // MARK: - Inits
    
    init(viewModel: ManageProjectMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subject
    
    let finishSubject = PublishSubject<Void>()
    
    override func bind() {
        let input = ManageProjectMainViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in () },
            closeManageProjectButtonTap: mainView.bottomSheet.buttonClose.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            deleteButtonTap: mainView.bottomSheet.buttonDelete.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            completeButtonTap: mainView.bottomSheet.buttonComplete.rx.tap
                .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance),
            finishSubject: finishSubject
        )
        
        let output = viewModel.transform(input: input)
        
        bindBottomSheet(output: output)
        bindAlert(output: output)
    }
    
    func bindBottomSheet(output: ManageProjectMainViewModel.Output) {
        
        // bottomSheet를 띄움
        rx.viewWillAppear
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, _  in
                this.mainView.showBottomSheet()
            })
            .disposed(by: disposeBag)
        
        // closebutton을 눌렀을 때 바텀시트를 내린 후 Coordinator 종료
        mainView.bottomSheet.buttonClose.rx.tap
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.mainView.dismissBottomSheet(completion: { _ in
                    this.finishSubject.onNext(())
                })
            })
            .disposed(by: disposeBag)
    }
    
    func bindAlert(output: ManageProjectMainViewModel.Output) {
        output.showCompleteAlert
            .withUnretained(self)
            .subscribe(onNext: { this, alert in
                this.mainView.dismissBottomSheet(completion: { _ in 
                    this.presentResultAlertView_Image_Title_Content(
                        source: self,
                        alert: alert,
                        darkbackground: false
                    )
                })
            })
            .disposed(by: disposeBag)
            
    }
}
