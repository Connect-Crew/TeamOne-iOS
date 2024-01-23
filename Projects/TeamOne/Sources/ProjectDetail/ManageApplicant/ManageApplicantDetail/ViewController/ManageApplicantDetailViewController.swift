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
    private let approveTarget = PublishRelay<String>()
    // alert에서 승인 버튼이 클릭된 경우 해당 서브젝트로 accept
    private let approveTap = PublishRelay<String>()
    
    private let rejectAlertResult = PublishSubject<Bool>()
    private let rejectReason = PublishRelay<String>()
    private let rejectTarget = PublishRelay<String>()
    // $0 == target, $1 == reason
    private let rejectTap = PublishRelay<(String, String)>()
    
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
            backButtonTap: navigationBar.backButtonTap
        )
        
        let output = viewModel.transform(input: input)
        
        output
            .sampleOutput
            .drive(tableView.rx.items(
                cellIdentifier: ManageApplicantDetailTableViewCell.identifier,
                cellType: ManageApplicantDetailTableViewCell.self)) { [weak self] _, item, cell in
                    
                    guard let self = self else { return }
                    
                    cell.bind()
                    
                    cell.rejectTap
                        .bind(onNext: {
                            self.rejectTarget.accept("김찬호")
                        })
                        .disposed(by: disposeBag)
                    
                    cell.approveTap
                        .bind(onNext: {
                            self.approveTarget.accept("김찬호")
                        })
                        .disposed(by: disposeBag)
                    
                    cell.copyButtonTap
                        .bind(onNext: { print($0)})
                        .disposed(by: cell.disposeBag)
                    
                    cell.profileTap
                        .bind(onNext: { print($0)})
                        .disposed(by: cell.disposeBag)
                    
                }
                .disposed(by: disposeBag)
        
        bindNavigationBar()
        bindReject()
        bindApprove()
    }
    
    private func bindReject() {
        rejectTarget
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
            .subscribe(onNext: { this, target in
                this.presentAlert_Title_TextView(source: this, alert: this.rejectReasonAlert)
            })
            .disposed(by: disposeBag)
        
        rejectReason
            .withLatestFrom(rejectTarget) { reason, target in
                return (target, reason)
            }
            .bind(to: rejectTap)
            .disposed(by: disposeBag)
        
        
        rejectTap
            .bind(onNext: {
                print("DEBUG: Reject Target: \($0.0), Reason: \($0.1) Tap")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindApprove() {
        approveTarget
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
        
        approveTap
            .bind(onNext: {
                print("DEBUG: Approve \($0) Tap")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNavigationBar() {
        navigationBar.initSetting(part: "UX / UI 디자이너")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.bringSubviewToFront(navigationBar)
        
        navigationBar.applyShadow(offsetX: 0, offsetY: 4, blurRadius: 8, color: UIColor(r: 158, g: 158, b: 158, a: 1), opacity: 0.3, positions: [.bottom])
    }
}

