//
//  ProjectSetStateRegionViewController.swift
//  TeamOne
//
//  Created by 강현준 on 12/2/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import DSKit
import RxSwift
import RxCocoa
import Then

final class ProjectSetStateRegionViewController: ViewController {

    let scrollView = BaseScrollView(frame: .zero)

    let labelStateTitle = UILabel().then {
        $0.setLabel(text: "프로젝트는 진행 전인가요, 진행 중인가요?", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let labelStateContent = UILabel().then {
        $0.setLabel(text: "진행 전인가요, 진행 중인가요?", typo: .caption2, color: .teamOne.grayscaleEight)
    }

    let buttonStateBefore = Button_IsSelected().then {
        $0.setTitle("진행 전", for: .normal)
    }

    let buttonStateRunning = Button_IsSelected().then {
        $0.setTitle("진행 중", for: .normal)
    }

    let labelRegionTitle = UILabel().then {
        $0.setLabel(text: "프로젝트는 어디에서 진행하시나요?", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let labelRegionContent = UILabel().then {
        $0.setLabel(text: "모집 화면에 태그가 생성되어 더욱 눈에 뛸 수 있어요!", typo: .caption2, color: .teamOne.grayscaleEight)
    }

    let buttonRegionOnline = Button_IsSelected().then {
        $0.setTitle("온라인", for: .normal)
    }

    let buttonRegionOnOffline = Button_IsSelected().then {
        $0.setTitle("온/오프라인", for: .normal)
    }

    let buttonRegionOffline = Button_IsSelected().then {
        $0.setTitle("오프라인", for: .normal)
    }

    let locaionListStackView = RegionListStackView(frame: .zero)

    let buttonBefore = UIButton().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.setButton(text: "이전", typo: .button1, color: .teamOne.grayscaleFive)
        $0.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        $0.setRound(radius: 8)
    }

    let buttonNext = Button_IsEnabled(enabledString: "다음", disabledString: "다음").then {
        $0.setRound(radius: 8)
        $0.isEnabled = false
        $0.setFont(typo: .button1)
    }

    lazy var contentStackView = UIStackView(arrangedSubviews: [
        createFirstStackView(),
        createSecondStackView()
    ]).then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }

    lazy var buttonStackView = UIStackView(arrangedSubviews: [
        buttonBefore,
        buttonNext
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.distribution = .fillEqually
        $0.spacing = 20
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    public func bind(output: ProjectCreateMainViewModel.Output) {
        
        output.projectCreateProps
            .map { $0.state }
            .drive(onNext: { [weak self] state in
                switch state {
                case nil:
                    self?.buttonStateBefore.isSelected = false
                    self?.buttonStateRunning.isSelected = false
                case .before:
                    self?.buttonStateBefore.isSelected = true
                    self?.buttonStateRunning.isSelected = false
                case .running:
                    self?.buttonStateBefore.isSelected = false
                    self?.buttonStateRunning.isSelected = true
                }
            })
            .disposed(by: disposeBag)

        output.projectCreateProps
            .map { $0.isOnline }
            .drive(onNext: { [weak self] isOnline in
                switch isOnline {
                case nil, .none:
                    self?.buttonRegionOnline.isSelected = false
                    self?.buttonRegionOffline.isSelected = false
                    self?.buttonRegionOnOffline.isSelected = false
                    self?.locaionListStackView.isUserInteractionEnabled = false
                    self?.locaionListStackView.resetSelect()
                case .offline:
                    self?.buttonRegionOnline.isSelected = false
                    self?.buttonRegionOffline.isSelected = true
                    self?.buttonRegionOnOffline.isSelected = false
                    self?.locaionListStackView.isUserInteractionEnabled = true
                case .onOffline:
                    self?.buttonRegionOnline.isSelected = false
                    self?.buttonRegionOffline.isSelected = false
                    self?.buttonRegionOnOffline.isSelected = true
                    self?.locaionListStackView.isUserInteractionEnabled = true
                case .online:
                    self?.buttonRegionOnline.isSelected = true
                    self?.buttonRegionOffline.isSelected = false
                    self?.buttonRegionOnOffline.isSelected = false
                    self?.locaionListStackView.isUserInteractionEnabled = false
                    self?.locaionListStackView.resetSelect()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        output.stateRegionCanNextPage
            .drive(buttonNext.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    override func layout() {

        self.view.addSubview(scrollView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.contentView.addSubview(contentStackView)

        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.view.addSubview(buttonStackView)

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonStackView.frame.height, right: 0)
    }

    func createFirstStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelStateTitle,
            labelStateContent,
            makeFirstButtonStackView()
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.setCustomSpacing(18, after: labelStateContent)
        }
    }

    func makeFirstButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            buttonStateBefore,
            buttonStateRunning
        ])
        .then {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    }

    func createSecondStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelRegionTitle,
            labelRegionContent,
            makeSecondButtonStackView(),
            makeLocationListStackView()
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.setCustomSpacing(18, after: labelRegionContent)
        }
    }

    func makeSecondButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            buttonRegionOnline,
            buttonRegionOnOffline,
            buttonRegionOffline
        ])
        .then {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    }

    func makeLocationListStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            locaionListStackView
        ])
        .then {
            $0.layoutMargins = UIEdgeInsets(top: 3, left: 15, bottom: 0, right: 15)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }
}



