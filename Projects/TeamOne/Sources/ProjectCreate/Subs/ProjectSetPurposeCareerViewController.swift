//
//  ProjectSetPurposeCareerViewController.swift
//  TeamOne
//
//  Created by 강현준 on 12/4/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit
import SnapKit
import Domain

final class ProjectSetPurposeCareerViewController: ViewController {

    let scrollView = BaseScrollView(frame: .zero)

    let labelPurposeTitle = UILabel().then {
        $0.setLabel(text: "프로젝트의 목적이 무엇인가요?", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let labelPurposeContent = UILabel().then {
        $0.setLabel(text: "두 가지 용도 중 하나를 선택해주세요.", typo: .caption2, color: .teamOne.grayscaleEight)
    }

    let buttonPurposeStartup = Button_IsSelected().then {
        $0.setTitle("예비창업", for: .normal)
    }

    let buttonPurposePortfolio = Button_IsSelected().then {
        $0.setTitle("포트폴리오", for: .normal)
    }

    let labelCareerTitle = UILabel().then {
        $0.setLabel(text: "선호하는 팀원들의 경력을 알려주세요.", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let labelCareerContent = UILabel().then {
        $0.setLabel(text: "취준생부터 경력 10년 이상까지 선택 가능합니다.", typo: .caption2, color: .teamOne.grayscaleEight)
    }

    let buttonMinCareer = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "경력 선택"
    }

    let labelBetweenCareerButton = UILabel().then {
        $0.setLabel(text: "~", typo: .button2, color: .teamOne.grayscaleSeven)
    }

    let buttonMaxCareer = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "경력 선택"
    }

    let dropBoxCareer = BaseDropBox()

    let buttonBefore = UIButton().then {
        $0.backgroundColor = .teamOne.grayscaleTwo
        $0.setButton(text: "이전", typo: .button1, color: .teamOne.grayscaleFive)
        $0.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        $0.setRound(radius: 8)
    }

    let buttonnoExperienceRequiredCheckBox = Button_CheckBox(text: "경력 무관", typo: .caption1, textColor: .teamOne.grayscaleSeven)
        .then {
            $0.type = .checkBox
            $0.isSelected = false
        }

    let buttonNext = Button_IsEnabled(enabledString: "다음", disabledString: "다음").then {
        $0.setRound(radius: 8)
        $0.isEnabled = false
        $0.setFont(typo: .button1)
    }

    lazy var setCareerStackView = UIStackView(arrangedSubviews: [
        buttonMinCareer,
        buttonMaxCareer
    ]).then {
        $0.spacing = 20
        $0.distribution = .fillEqually
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
        $0.backgroundColor = .white
    }

    private let careerDataSource = Career.allCareerStringValues()
    private var careerMaxDataSource: [String] = []
    
    let minCareerSubject = PublishSubject<Career>()
    let maxCareerSubject = PublishSubject<Career>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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

        self.scrollView.contentView.addSubview(labelBetweenCareerButton)

        labelBetweenCareerButton.snp.makeConstraints {
            $0.center.equalTo(setCareerStackView)
        }
    }

    override func bind() {
        
        let minCareerSubject = PublishSubject<(String, Int)>()
        let maxCareerSubject = PublishSubject<(String, Int)>()

        buttonMinCareer.button.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { careerVC, _ in

                if careerVC.buttonMinCareer.isDropDownOpend == false {
                    
                    careerVC.dropBoxCareer.openDropBox(
                        dataSource: careerVC.careerDataSource,
                        onSelectSubject: minCareerSubject
                    )
                    
                    careerVC.buttonMinCareer.isDropDownOpend = true
                }
            })
            .disposed(by: disposeBag)

        minCareerSubject
            .withUnretained(self)
            .subscribe(onNext: { careerVC, result in
                let selectedCareer = Career.findCareer(string: result.0)
                
                careerVC.minCareerSubject.onNext(selectedCareer)
                
                careerVC.buttonMinCareer.isDropDownOpend = false
                careerVC.buttonMinCareer.isSelected = true

                let range = (result.1)..<(careerVC.careerDataSource.count)

                careerVC.careerMaxDataSource = Array(careerVC.careerDataSource[range])
            })
            .disposed(by: disposeBag)

        buttonMaxCareer.button.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { careerVC, _ in

                if careerVC.buttonMaxCareer.isDropDownOpend == false && careerVC.buttonMinCareer.isDropDownOpend == false {

                    careerVC.dropBoxCareer.openDropBox(
                        dataSource: careerVC.careerMaxDataSource,
                        onSelectSubject: maxCareerSubject
                    )

                    careerVC.buttonMaxCareer.isDropDownOpend = true

                }
            })
            .disposed(by: disposeBag)

        maxCareerSubject
            .withUnretained(self)
            .subscribe(onNext: { careerVC, result in
                let selectedCareer = Career.findCareer(string: result.0)
                
                careerVC.maxCareerSubject.onNext(selectedCareer)
            
                careerVC.buttonMaxCareer.isDropDownOpend = false
                careerVC.buttonMaxCareer.isSelected = true
            })
            .disposed(by: disposeBag)
    }

    func bind(output: ProjectCreateMainViewModel.Output) {

        output.isNoRequiredExperience
            .drive(buttonnoExperienceRequiredCheckBox.rx.isSelected)
            .disposed(by: disposeBag)

        output.isNoRequiredExperience
            .drive(onNext: { [weak self] bool in
                if bool == true {
                    self?.buttonMinCareer.isUserInteractionEnabled = false
                    self?.buttonMaxCareer.isUserInteractionEnabled = false
                } else {
                    self?.buttonMinCareer.isUserInteractionEnabled = true
                    self?.buttonMaxCareer.isUserInteractionEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        output.minCareer
            .map { $0.toString() }
            .drive(onNext: { [weak self] string in
                self?.buttonMinCareer.selectedText = string
            })
            .disposed(by: disposeBag)
        
        output.minCareerSelected
            .drive(buttonMinCareer.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.maxCareer
            .map { $0.toString() }
            .drive(onNext: { [weak self] string in
                self?.buttonMaxCareer.selectedText = string
            })
            .disposed(by: disposeBag)
        
        output.maxCareerSelected
            .drive(buttonMaxCareer.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.purpose
            .drive(onNext: { [weak self] purpose in
                switch purpose {
                case .none:
                    self?.buttonPurposePortfolio.isSelected = false
                    self?.buttonPurposeStartup.isSelected = false
                case .portfolio:
                    self?.buttonPurposePortfolio.isSelected = true
                    self?.buttonPurposeStartup.isSelected = false
                case .startup:
                    self?.buttonPurposePortfolio.isSelected = false
                    self?.buttonPurposeStartup.isSelected = true
                }
            })
            .disposed(by: disposeBag)
        
        output.purposeCareerCanNextPage
            .drive(buttonNext.rx.isEnabled)
            .disposed(by: disposeBag)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonStackView.frame.height, right: 0)
    }

    func createFirstStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelPurposeTitle,
            labelPurposeContent,
            makeFirstButtonStackView()
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.setCustomSpacing(18, after: labelPurposeContent)
        }
    }

    func makeFirstButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            buttonPurposeStartup,
            buttonPurposePortfolio
        ])
        .then {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    }

    func createSecondStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelCareerTitle,
            labelCareerContent,
            buttonnoExperienceRequiredCheckBox,
            setCareerStackView,
            dropBoxCareer
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.setCustomSpacing(18, after: labelPurposeContent)
            $0.setCustomSpacing(10, after: buttonnoExperienceRequiredCheckBox)
            $0.setCustomSpacing(20, after: setCareerStackView)
        }
    }
}
