//
//  UserExpleViewController.swift
//  TeamOne
//
//  Created by 강현준 on 1/12/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import SnapKit
import DSKit
import Domain

final class UserExpleViewController: ViewController {
    
    private lazy var alert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "[ \(target.profile.nickname) ] 님을 내보내시겠습니까?",
        content: "팀원들과 상의 후 결정해주시기 바랍니다.",
        availableCancle: true,
        resultSubject: selectExpleResult
    )
    
    private lazy var expleContentView = ExpleContentView()
    
    private let selectExpleResult = PublishSubject<Bool>()
    
    let expleResult: PublishRelay<ProjectMember>
    
    private let target: ProjectMember
    
    private let backgroundButton = UIButton().then {
        $0.backgroundColor = .teamOne.transparent
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    // MARK: - Inits
    
    init(target: ProjectMember,
         expleResult: PublishRelay<ProjectMember>) {
        self.target = target
        self.expleResult = expleResult
        super.init(nibName: nil, bundle: nil)
    }
    
    override func layout() {
        layoutBackgroundButton()
        layoutExpleContentView()
    }
    
    private func layoutBackgroundButton() {
        self.view.addSubview(backgroundButton)
        
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutExpleContentView() {
        
        self.view.addSubview(expleContentView)
        
        expleContentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(45)
            $0.trailing.equalToSuperview().inset(45)
            $0.center.equalToSuperview()
        }
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: false)
    }
    
    override func bind() {
        bindSelectExple()
    }
    
    func bindSelectExple() {
        rx.viewDidAppear
            .asSignal()
            .withUnretained(self)
            .emit(onNext: { this, _ in
                this.presentResultAlertView_Image_Title_Content(
                    source: this,
                    alert: this.alert,
                    darkbackground: false
                )
            })
            .disposed(by: disposeBag)
        
        let expleTap = selectExpleResult
            .filter { $0 == true }
        
        let cancleTap = selectExpleResult
            .filter { $0 == false }
        
        cancleTap
            .asSignal(onErrorJustReturn: false)
            .withUnretained(self)
            .emit(onNext: { this, _ in
                this.dismissVC()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

