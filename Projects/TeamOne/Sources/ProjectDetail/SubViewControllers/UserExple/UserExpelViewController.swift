//
//  UserExpelViewController.swift
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

final class UserExpelViewController: ViewController {
    
    private lazy var alert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "[ \(target.profile.nickname) ] 님을 내보내시겠습니까?",
        content: "팀원들과 상의 후 결정해주시기 바랍니다.",
        availableCancle: true,
        resultSubject: selectExpelResult
    )
    
    private lazy var expelSuccessAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .complete,
        title: "내보내기가 완료되었습니다.",
        content: "소중한 의견 감사합니다.",
        availableCancle: false,
        resultSubject: expelSuccessResult
    )
    
    private lazy var expelContentView = ExpelContentView()
    
    // 알럿 result subject
    private let selectExpelResult = PublishSubject<Bool>()
    private let expelSuccessResult = PublishSubject<Bool>()
    private let expelFailureResult = PublishSubject<Bool>()
    
    public let expelProps: PublishRelay<(projectId: Int, userId: Int, reasons: [User_ExpelReason])>
    private let expelSuccess: PublishRelay<Void>
    private let expelFailure: PublishRelay<Error>
    
    private let target: ProjectMember
    private let project: Project
    
    private let backgroundButton = UIButton().then {
        $0.backgroundColor = .teamOne.transparent
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    // MARK: - Inits
    
    init(project: Project,
         target: ProjectMember,
         expelSuccess: PublishRelay<Void>,
         expelFailure: PublishRelay<Error>,
         expelProps: PublishRelay<(projectId: Int, userId: Int, reasons: [User_ExpelReason])>
    ) {
        self.project = project
        self.target = target
        self.expelSuccess = expelSuccess
        self.expelFailure = expelFailure
        self.expelProps = expelProps
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func layout() {
        layoutBackgroundButton()
        layoutExpelContentView()
    }
    
    private func layoutBackgroundButton() {
        self.view.addSubview(backgroundButton)
        
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func layoutExpelContentView() {
        
        self.view.addSubview(expelContentView)
        
        expelContentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(45)
            $0.trailing.equalToSuperview().inset(45)
            $0.center.equalToSuperview()
        }
        
        expelContentView.isHidden = true
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: false)
    }
    
    override func bind() {
        bindSelectExpel()
        bindSelectExpelContent()
        bindExpelResult()
    }
    
    /// 내보내기 알럿 바인딩
    private func bindSelectExpel() {
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
        
        let selectExpelResultSignal = selectExpelResult
            .asSignal(onErrorJustReturn: false)
        
        let expelTap = selectExpelResultSignal
            .filter { $0 == true }
        
        let cancleTap = selectExpelResultSignal
            .filter { $0 == false }
        
        expelTap
            .withUnretained(self)
            .emit(onNext: { this, _ in
                this.expelContentView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        cancleTap
            .withUnretained(self)
            .emit(onNext: { this, _ in
                this.dismissVC()
            })
            .disposed(by: disposeBag)
    }
    
    /// 내보내기 사유 선택 뷰 바인딩
    private func bindSelectExpelContent() {
        
        let selectedTap = expelContentView.expelSelected
        
        let cancleTap = expelContentView.cancleSelected
        
        selectedTap
            .withUnretained(self)
            .map { (this, reason)  in
                return (
                    projectId: this.project.id,
                    userId: this.target.profile.id,
                    reasons: reason
                )
            }
            .withUnretained(self)
            .bind(onNext: { this, props in
                this.expelContentView.isHidden = true
                this.expelProps.accept(props)
            })
            .disposed(by: disposeBag)
        
        cancleTap
            .asSignal()
            .withUnretained(self)
            .emit(onNext: { this, _ in
                this.dismissVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindExpelResult() {
        
        // 성공 케이스
        
        expelSuccess
            .withUnretained(self)
            .map { this, _ in
                return this.expelSuccessAlert
            }
            .withUnretained(self)
            .bind(onNext: { this, alert in
                this.presentResultAlertView_Image_Title_Content(
                    source: this,
                    alert: alert,
                    darkbackground: false
                )
            })
            .disposed(by: disposeBag)
        
        expelSuccessResult
            .withUnretained(self)
            .bind(onNext: { this, _ in
                this.dismissVC()
            })
            .disposed(by: disposeBag)
        
        // 실패 에러 처리
        
        expelFailure
            .withUnretained(self)
            .bind(onNext: { this, error in
                this.presentErrorAlert(
                    error: error,
                    finishSubject: this.expelFailureResult
                )
            })
            .disposed(by: disposeBag)
        
        expelFailureResult
            .withUnretained(self)
            .bind(onNext: { this, _ in
                this.dismissVC()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

