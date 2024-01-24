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

final class ManageProjectMainVC: BaseModalViewControl {
    
    let mainView = ManageProjectMainView(frame: .zero)
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    // MARK: - Inits
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Relay
    
    let modifySubject = PublishRelay<Void>()
    let manageApplicantsSubject = PublishRelay<Void>()
    
    override func bind() {
        bindBottomSheet()
    }
    
    func bindBottomSheet() {
        
        // bottomSheet를 띄움
        rx.viewWillAppear
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, _  in
                this.mainView.showBottomSheet(completion: {
                    this.setInteractiveDismiss(
                        gestureView: this.mainView.bottomSheet,
                        targetView: this.mainView.bottomSheet
                    )
                })
            })
            .disposed(by: disposeBag)
        
        // closebutton을 눌렀을 때 바텀시트 dismiss
        mainView.bottomSheet.buttonClose.rx.tap
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.mainView.dismissBottomSheet(completion: { _ in
                    this.dismiss(animated: false)
                })
            })
            .disposed(by: disposeBag)
        
        // 수정하기를 누르면 바텀시트를 내린 후 이동
        mainView.bottomSheet.buttonModify.rx.tap
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.mainView.dismissBottomSheet(completion: { _ in
                    this.dismiss(animated: false, completion: {
                        this.modifySubject.accept(())
                    })
                })
            })
            .disposed(by: disposeBag)
        
        mainView.bottomSheet.buttonManageApplicants.rx.tap
            .withUnretained(self)
            .bind(onNext: { this, _ in
                this.mainView.dismissBottomSheet(completion: { _ in
                    this.dismiss(animated: false, completion: {
                        this.manageApplicantsSubject.accept(())
                    })
                })
            })
            .disposed(by: disposeBag)
        
        mainView.buttonBackground.rx.tap
            .withUnretained(self)
            .bind(onNext: { this, _ in
                this.mainView.dismissBottomSheet(completion: { _ in
                    this.dismiss(animated: false)
                })
            })
            .disposed(by: disposeBag)
    }
    
}
