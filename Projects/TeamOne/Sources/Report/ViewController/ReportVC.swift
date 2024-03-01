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
    
    public override func loadView() {
        view = mainView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.mainViewContainer.adjustForKeyboard(disposeBag: disposeBag)
        
        if let reactor = self.reactor {
            self.bind(reactor: reactor)
        }
    }
    
    private func bind(reactor: ReportReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ReportReactor) {
        mainView.abusiveLanguage.rx.tap
            .map { ReportReactor.Action.tapReport(.abusiveLanguage) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ReportReactor) {
        reactor.state
            .map { $0.abusiveLanguage }
            .bind(to: mainView.abusiveLanguage.rx.isSelected )
            .disposed(by: disposeBag)
    }
}
