//
//  TaskSelectView.swift
//  TeamOne
//
//  Created by 강창혁 on 2/25/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import SnapKit
import Then
import RxSwift
import Domain
import RxCocoa

final class TaskSelectView: View {
    
    private let careerYears = [
        "준비생", "신입", "1년", "2년", "3년", "4년", "5년", "6년", "7년", "8년", "9년", "10년 이상",
    ]
    
    let headerLabel = UILabel()
    
    private let mainTaskLabel = UILabel()
    
    private let verticalDivider = UIView().then {
        $0.setDivider(height: 14.2, width: 0.5, color: .grayscaleFive)
    }
    
    private let careerTaskLabel = UILabel()
    
    let deleteButton = UIButton().then {
        $0.setImage(.image(dsimage: .delete3), for: .normal)
        $0.isHidden = true
    }
    
    private lazy var descriptionStackView = UIStackView(
        arrangedSubviews: [mainTaskLabel, verticalDivider, careerTaskLabel]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.isHidden = true
    }
    
    private let mainTaskSelectButton = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "직무 대분류 선택"
    }
    
    private let subTaskSelectButton = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "직무 소분류 선택"
    }
    private let careerSelectButton = Button_DropBoxResult(frame: .zero).then {
        $0.noneSelectedText = "경력선택"
        $0.isHidden = true
    }
    
    private lazy var selectedMainTask = PublishSubject<(String, Int)>()
    private lazy var selectedsubTask = PublishSubject<(String, Int)>()
    private lazy var selectedCareer = PublishSubject<(String, Int)>()
    lazy var selectedTaskPart = BehaviorSubject<Parts?>(value: nil)
    private var selectedCarrerYear: String? = ""
    private lazy var taskStackView = UIStackView(
        arrangedSubviews: [mainTaskSelectButton, subTaskSelectButton]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
    }
    
    private lazy var mainStackView = UIStackView(
        arrangedSubviews: [taskStackView, taskDropBox, careerSelectButton, careerDropBox]
    ).then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    let taskDropBox = BaseDropBox()
    let careerDropBox = BaseDropBox()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        bindTaskSelectItems()
        bindDeletedButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.backgroundColor = .white
        self.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalToSuperview().offset(24)
        }
        
        self.addSubview(descriptionStackView)
        descriptionStackView.snp.makeConstraints {
            $0.centerY.equalTo(headerLabel)
            $0.leading.equalTo(headerLabel.snp.trailing).offset(10)
        }
        self.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 16))
            $0.centerY.equalTo(headerLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        self.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func bindTaskSelectItems() {
        
        mainTaskSelectButton.button.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { this, _ in
                this.descriptionStackView.isHidden = true
                this.deleteButton.isHidden = true
                this.careerSelectButton.isHidden = true
                let main = this.mainTaskSelectButton
                let sub = this.subTaskSelectButton
                let career = this.careerSelectButton
                
                sub.isDropDownOpend = false
                sub.isSelected = false
                
                career.isDropDownOpend = false
                career.isSelected = false
                
                guard main.isDropDownOpend == false else {
                    
                    this.taskDropBox.closeDropBox()
                    main.isDropDownOpend = false
                    
                    return
                }
                this.taskDropBox.openDropBox(
                    dataSource: KM.shared.jobMajorCategory,
                    onSelectSubject: this.selectedMainTask
                )
                main.isDropDownOpend = true
                
            }
            .disposed(by: disposeBag)
        
        selectedMainTask
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                let mainTaskButton = this.mainTaskSelectButton
                let subTaskButton = this.subTaskSelectButton
                
                mainTaskButton.isDropDownOpend = false
                mainTaskButton.isSelected = true
                mainTaskButton.selectedText = result.0
                
                subTaskButton.isDropDownOpend = false
                subTaskButton.isSelected = false
                
            })
            .disposed(by: disposeBag)
        
        subTaskSelectButton.button.rx.tap
            .throttle(.seconds(1), latest: true, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { this, _ in
                
                let mainTaskButton = this.mainTaskSelectButton
                let subTaskButton = this.subTaskSelectButton
                
                if mainTaskButton.isSelected == true && subTaskButton.isDropDownOpend == false {
                    this.taskDropBox.openDropBox(
                        dataSource: KM.shared.jobSubCategory[mainTaskButton.selectedText ?? ""] ?? [],
                        onSelectSubject: this.selectedsubTask
                    )
                    subTaskButton.isDropDownOpend = true
                } else if mainTaskButton.isSelected == true && subTaskButton.isDropDownOpend == true {
                    this.taskDropBox.closeDropBox()
                    subTaskButton.isDropDownOpend = false
                }
            }
            .disposed(by: disposeBag)
        
        selectedsubTask
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                
                let mainTaskButton = this.mainTaskSelectButton
                let subTaskButton = this.subTaskSelectButton
                
                subTaskButton.isDropDownOpend = false
                subTaskButton.isSelected = true
                subTaskButton.selectedText = result.0
                
                this.careerSelectButton.isHidden = false
                
            })
            .disposed(by: disposeBag)
        
        careerSelectButton.button.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                
                guard this.careerSelectButton.isDropDownOpend == false else {
                    this.careerDropBox.closeDropBox()
                    this.careerSelectButton.isDropDownOpend = false
                    return
                }
                
                this.careerDropBox.openDropBox(
                    dataSource: this.careerYears,
                    onSelectSubject: this.selectedCareer
                )
                this.careerSelectButton.isDropDownOpend = true

            }
            .disposed(by: disposeBag)
        
        selectedCareer
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                this.careerSelectButton.isDropDownOpend = false
                this.careerSelectButton.isSelected = true
                this.careerSelectButton.selectedText = result.0
                guard let mainTask = this.mainTaskSelectButton.selectedText,
                      let subTask = this.subTaskSelectButton.selectedText else { return }
                
                this.careerTaskLabel.setLabel(
                    text: result.0,
                    typo: .caption1,
                    color: .teamOne.mainColor
                )
                this.selectedCarrerYear = result.0
                
                let key = KM.shared.key(name: subTask)
                let part = Parts(key: key, part: subTask, category: mainTask)
                this.selectedTaskPart.onNext(part)
            })
            .disposed(by: disposeBag)
        
        selectedTaskPart
            .withUnretained(self)
            .subscribe(onNext: { this, result in
                guard let result else {
                    this.descriptionStackView.isHidden = true
                    this.deleteButton.isHidden = true
                    this.careerSelectButton.isHidden = true
                    this.mainTaskSelectButton.isSelected = false
                    this.mainTaskSelectButton.isDropDownOpend = false
                    this.subTaskSelectButton.isSelected = false
                    this.subTaskSelectButton.isDropDownOpend = false
                    this.careerSelectButton.isSelected = false
                    this.careerSelectButton.isDropDownOpend = false
                    return
                }
                this.mainTaskLabel.setLabel(text: result.category + "·" + result.part, typo: .caption1, color: .teamOne.mainColor)
                
                this.mainTaskSelectButton.isSelected = true
                this.mainTaskSelectButton.selectedText = result.category
                this.subTaskSelectButton.isSelected = true
                this.subTaskSelectButton.selectedText = result.part
                this.descriptionStackView.isHidden = false
                this.deleteButton.isHidden = false
                
                this.careerSelectButton.isHidden = false
                this.careerSelectButton.isSelected = true
                this.careerSelectButton.selectedText = this.selectedCarrerYear
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDeletedButtonTapped() {
        deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.selectedTaskPart.onNext(nil)
            }
            .disposed(by: disposeBag)
    }
}
