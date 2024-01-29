//
//  ManageApplicantDetailViewController.swift
//  TeamOne
//
//  Created by 강현준 on 1/22/24.
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

final class ManageApplicantDetailViewController: ViewController {
    
    private let navigationBar = ManageApplicantDetailNavigationView()
    
    private let tableView = UITableView().then {
        $0.register(ManageApplicantDetailTableViewCell.self, forCellReuseIdentifier: ManageApplicantDetailTableViewCell.identifier)
        $0.backgroundColor = .clear
    }
    
    private let emptyApplicantLabel = UILabel().then {
        $0.setLabel(text: "아직 지원자가 없어요.", typo: .body3, color: .teamOne.grayscaleFive)
    }
    
    private lazy var approveAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .complete,
        title: "[]님의 지원을 승인하시겠습니까?",
        content: "지원자가 팀원에 합류하게 됩니다.",
        availableCancle: true,
        resultSubject: approveAlertResult
    )
    
    private lazy var rejectAlert = ResultAlertView_Image_Title_Content_Alert(
        image: .warnning,
        title: "[]님의 지원을 거절하시겠습니까?",
        content: "거절한 지원자는 해당 파트 외 다른 직무에 재지원 가능합니다.",
        availableCancle: true,
        resultSubject: rejectAlertResult
    )
    
    private lazy var rejectReasonAlert = AlertView_Title_TextView_Item(
        title: "거절 사유를 알려주세요",
        placeHolder: "팀원(Team no.1의 배려있는 문화 만들기에 동참해주세요. (최대 1,000자 입력 가능합니다.)",
        okButtonTitle: "거절",
        maxTextCount: 1000,
        callBack: { [weak self] bool, content in
            if bool {
                self?.rejectReason.accept(content)
            }
        }
    )
    
    private let viewModel: ManageApplicantDetailViewModel
    
    // alert의 result를 받기 위해
    private let approveAlertResult = PublishSubject<Bool>()
    // approve의 target을 갖고있도록
    private let approveTarget = PublishRelay<Int>()
    // alert에서 승인 버튼이 클릭된 경우 해당 서브젝트로 accept
    private let approveTap = PublishRelay<Int>()
    
    private let rejectAlertResult = PublishSubject<Bool>()
    private let rejectReason = PublishRelay<String>()
    private let rejectTarget = PublishRelay<Int>()
    // $0 == row, $1 == reason
    private let rejectTap = PublishRelay<(Int, String)>()
    
    private let profileTap = PublishRelay<Int>()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    // MARK: - Inits
    
    init(viewModel: ManageApplicantDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        
        // navigationBar
        self.view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        // tableView
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        // emptyView
        self.view.addSubview(emptyApplicantLabel)
        
        emptyApplicantLabel.snp.makeConstraints {
            $0.center.equalTo(tableView)
        }
    }
    
    override func bind() {
        let input = ManageApplicantDetailViewModel.Input(
            viewDidLoad: rx.viewWillAppear.take(1).map { _ in return () },
            backButtonTap: navigationBar.backButtonTap,
            rejectButtonTap: rejectTap,
            approveButtonTap: approveTap
        )
        
        let output = viewModel.transform(input: input)
        
        output
            .appliesList
            .drive(tableView.rx.items(
                cellIdentifier: ManageApplicantDetailTableViewCell.identifier,
                cellType: ManageApplicantDetailTableViewCell.self)) { [weak self] row, item, cell in
                    
                    guard let self = self else { return }
                    
                    cell.bind()
                    
                    cell.rejectTap
                        .bind(to: self.rejectTarget)
                        .disposed(by: cell.disposeBag)
                    
                    cell.approveTap
                        .bind(to: self.approveTarget)
                        .disposed(by: cell.disposeBag)
                    
                    cell.profileTap
                        .bind(to: self.profileTap)
                        .disposed(by: cell.disposeBag)
                    
                    var cellState = ManageApplicantDetailTableViewCell.ApplyState.waiting
                    
                    switch item.state {
                    case .accept: cellState = .accept
                    case .reject: cellState = .rejected
                    case .waiting: cellState = .waiting
                    }
                    
                    let cellItem = ManageApplicantDetailTableViewCell.Item(
                        applyState: cellState,
                        nickname: item.user.nickname,
                        profile: item.user.profile,
                        temperature: item.user.temperature,
                        responseRate: item.user.responseRate,
                        parts: item.user.parts.map { (category: $0.category, part: $0.part)},
                        introduction: item.user.introduction,
                        contact: item.contact,
                        message: item.message
                    )
                    
                    cell.initSetting(item: cellItem, row: row)
                    
                }
                .disposed(by: disposeBag)
        
        bindNavigationBar(status: output.status)
        bindReject(list: output.appliesList)
        bindApprove(list: output.appliesList)
        bindError(error: output.error)
        bindEmpty(empty: output.appliesList.map { $0.isEmpty })
    }
    
    private func bindReject(list: Driver<[Applies]>) {
        rejectTarget
            .withLatestFrom(list) { row, list in
                return list[row].user.nickname
            }
            .withUnretained(self)
            .map { this, target in
                this.rejectAlert.title = "\(target)님의 지원을 거절하시겠습니까?"
                return this.rejectAlert
            }
            .withUnretained(self)
            .bind(onNext: { this, alert in
                this.presentResultAlertView_Image_Title_Content(
                    source: this,
                    alert: alert,
                    okButtonTitle: "거절"
                )
            })
            .disposed(by: disposeBag)
        
        rejectAlertResult
            .filter { $0 == true }
            .withLatestFrom(rejectTarget)
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.presentAlert_Title_TextView(source: this, alert: this.rejectReasonAlert)
            })
            .disposed(by: disposeBag)
        
        rejectReason
            .withLatestFrom(rejectTarget) { reason, target in
                return (target, reason)
            }
            .bind(to: rejectTap)
            .disposed(by: disposeBag)
    }
    
    private func bindApprove(list: Driver<[Applies]>) {
        approveTarget
            .withLatestFrom(list) { row, list in
                return list[row].user.nickname
            }
            .withUnretained(self)
            .map { this, target in
                this.approveAlert.title = "\(target)님의 지원을 승인하시겠습니까?"
                return this.approveAlert
            }
            .withUnretained(self)
            .bind(onNext: { this, alert in
                this.presentResultAlertView_Image_Title_Content(
                    source: this,
                    alert: alert
                )
            })
            .disposed(by: disposeBag)
        
        approveAlertResult
            .filter { $0 == true }
            .withLatestFrom(approveTarget)
            .withUnretained(self)
            .subscribe(onNext: { this, target in
                this.approveTap.accept(target)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigationBar(status: Driver<ApplyStatus>) {
        status
            .drive(onNext: { [weak self] status in
                self?.navigationBar.initSetting(part: status.partDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindError(error: Signal<Error>) {
        error
            .emit(onNext: { [weak self] error in
                self?.presentErrorAlert(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindEmpty(empty: Driver<Bool>) {
        empty
            .drive(onNext: { [weak self] in
                self?.emptyApplicantLabel.isHidden = !$0
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.bringSubviewToFront(navigationBar)
        
        navigationBar.applyShadow(offsetX: 0, offsetY: 4, blurRadius: 8, color: UIColor(r: 158, g: 158, b: 158, a: 1), opacity: 0.3, positions: [.bottom])
    }
}

