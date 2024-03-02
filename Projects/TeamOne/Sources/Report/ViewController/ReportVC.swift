//
//  ReportVC.swift
//  TeamOne
//
//  Created by Junyoung on 3/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import ReactorKit
import UIKit

public class ReportVC: UIViewController {
    
    private let mainView = ReportMainView()
    
    var disposeBag = DisposeBag()
    
    var reactor: ReportReactor?
    
    var reportName: String?
    
    public override func loadView() {
        view = mainView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    func setup() {
        mainView.mainViewContainer.adjustForKeyboard(disposeBag: disposeBag)
        
        mainView.setReportName(reportName ?? "")
        
        if let reactor = self.reactor {
            self.bind(reactor: reactor)
        }
    }
    
    private func bind(reactor: ReportReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ReportReactor) {
        mainView.abusiveLanguageButton.rx.tap
            .map { ReportReactor.Action.tapReport(.abusiveLanguage) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.lowParticipationButton.rx.tap
            .map { ReportReactor.Action.tapReport(.lowParticipation) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.spammingButton.rx.tap
            .map { ReportReactor.Action.tapReport(.spamming) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.promotionalContentButton.rx.tap
            .map { ReportReactor.Action.tapReport(.promotionalContent) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.inappropriateNicknameOrProfilePhotoButton.rx.tap
            .map { ReportReactor.Action.tapReport(.inappropriateNicknameOrProfilePhoto) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.privacyInvasionButton.rx.tap
            .map { ReportReactor.Action.tapReport(.privacyInvasion) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.adultContentButton.rx.tap
            .map { ReportReactor.Action.tapReport(.adultContent) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.otherButton.rx.tap
            .map { ReportReactor.Action.tapReport(.other) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.otherTextField.rx.text
            .map { ReportReactor.Action.otherText($0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .map { ReportReactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.confirmButton.rx.tap
            .map { ReportReactor.Action.confirm }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(_ reactor: ReportReactor) {
        reactor.state
            .map { $0.abusiveLanguage }
            .bind(to: mainView.abusiveLanguageButton.rx.isSelected )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.lowParticipation }
            .bind(to: mainView.lowParticipationButton.rx.isSelected )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.spamming }
            .bind(to: mainView.spammingButton.rx.isSelected )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.promotionalContent }
            .bind(to: mainView.promotionalContentButton.rx.isSelected )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.inappropriateNicknameOrProfilePhoto }
            .bind(to: mainView.inappropriateNicknameOrProfilePhotoButton.rx.isSelected )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.privacyInvasion }
            .bind(to: mainView.privacyInvasionButton.rx.isSelected )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.adultContent }
            .bind(to: mainView.adultContentButton.rx.isSelected )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.other }
            .bind(to: mainView.otherButton.rx.isSelected )
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.otherTextState }
            .withUnretained(self)
            .subscribe(onNext: { this, state in
                this.mainView.setOtherState(state)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.reportState }
            .withUnretained(self)
            .subscribe(onNext: { this, reportState in
                switch reportState {
                case .uncheckedError:
                    this.mainView.setErrorState(error: true, msg: "신고하려는 사유를 한 개 이상 선택해주세요.")
                    this.mainView.confirmButton.isEnabled = false
                case .otherTextEmptyError:
                    this.mainView.setErrorState(error: true, msg: "내용을 입력해주세요.")
                    this.mainView.confirmButton.isEnabled = false
                case .normal:
                    this.mainView.setErrorState(error: false)
                    this.mainView.confirmButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isViewDismiss }
            .filter { $0 == true }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
    }
}
