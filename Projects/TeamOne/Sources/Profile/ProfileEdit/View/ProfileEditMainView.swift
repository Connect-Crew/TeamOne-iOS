//
//  ProfileEditMainView.swift
//  TeamOne
//
//  Created by 강창혁 on 2/24/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import RxKeyboard
import UIKit
import Domain
import SnapKit
import Then
import Core
import DSKit

final class ProfileEditMainView: View {
    
    let navBar = ProfileEditNavBar()
    
    private let scrollView = BaseScrollView()
    
    // MARK: - 프로필 이미지
    
    private let editProfileImageBackground = UIView()
    
    private let editProfileImageButton = UIButton().then {
        let editProfileDefaultImage = UIImage.image(dsimage: .profileEdit)
        $0.setImage(editProfileDefaultImage, for: .normal)
    }
    
    private let baseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    // MARK: - 닉네임
    
    private let nickNameHeaderLabel = UILabel().then {
        $0.setLabel(text: "닉네임", typo: .body4, color: .black)
    }
    
    private let nickNameTextField = UITextField().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.setFont(font: .button2),
            .foregroundColor: UIColor.teamOne.grayscaleFive
        ]
        
        var attributedString = NSAttributedString(
            string: "닉네임을 입력해주세요. (최대 10자)",
            attributes: attributes
        )
        $0.attributedPlaceholder = attributedString
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.teamOne.grayscaleFive.cgColor
        $0.layer.cornerRadius = 8
        $0.font = .setFont(font: .button2)
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: $0.frame.height))
        $0.leftView = leftPadding
        $0.leftViewMode = .always
    }
    
    private let inputNickNameView = UIView()
    
    // MARK: - 소개
    
    private let introduceHeaderLabel = UILabel().then {
        $0.setLabel(text: "소개", typo: .body4, color: .black)
    }
    
    private let introduceTextView = TextView_DynamicHeight().then {
        $0.placeholder = "소개를 입력해주세요. (최대 150자)"
        $0.placeholderTextColor = .teamOne.grayscaleFive
        $0.setFont(typo: .button2)
        $0.setLayer(width: 0.5, color: .teamOne.grayscaleFive)
        $0.setRound(radius: 8)
        $0.maxTextCount = 150
        $0.backgroundColor = .white
    }
    
    private let inputIntroduceView = UIView()
    
    // MARK: - 직무 선택 1,2
    
    private let firstTaskSelectView = TaskSelectView().then {
        $0.headerLabel.setLabel(text: "직무 1", typo: .body4, color: .black)
    }
    
    private let secondTaskSelectView = TaskSelectView().then {
        $0.headerLabel.setLabel(text: "직무 2", typo: .body4, color: .black)
        $0.isHidden = true
    }
    
    let selectedTask = PublishSubject<[Parts?]>()
    
    // MARK: - 포트폴리오
    
    let portfolioSelectView = PortfolioSelectView().then {
        $0.backgroundColor = .white
    }
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        layout()
        bindTask()
        bindPortfolioNameEntered()
        scrollView.backgroundColor = .teamOne.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - bind
    
    private func bindTask() {
        firstTaskSelectView.selectedTaskPart
            .withUnretained(self)
            .bind(onNext: { this, parts in
                guard let parts else { return }
                this.secondTaskSelectView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        firstTaskSelectView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                guard let secondTask = try? this.secondTaskSelectView.selectedTaskPart.value() else {
                    this.secondTaskSelectView.isHidden = true
                    return
                }
                this.firstTaskSelectView.selectedCarrerYear = this.secondTaskSelectView.selectedCarrerYear
                this.firstTaskSelectView.selectedTaskPart.onNext(secondTask)
                this.secondTaskSelectView.isHidden = true
                this.secondTaskSelectView.selectedTaskPart.onNext(nil)
            }
            .disposed(by: disposeBag)
        
        secondTaskSelectView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.secondTaskSelectView.isHidden = true
            }
            .disposed(by: disposeBag)
    }
    
    private func bindPortfolioNameEntered() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [scrollView] height in
                scrollView.contentInset.bottom = height
                scrollView.scrollRectToVisible(CGRect(x: 0, y: scrollView.contentSize.height - 1, width: 1, height: 1), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func findFirstResponder(in view: UIView) -> UIView? {
        for subview in view.subviews {
            if subview.isFirstResponder {
                return subview
            }
            
            if let recursiveSubview = findFirstResponder(in: subview) {
                return recursiveSubview
            }
        }
        return nil
    }
    
    // MARK: - Layout
    
    private func layout() {
        layoutNavBar()
        layoutScrollView()
        layoutProfileImageView()
        layoutBaseStackView()
        layoutInputNickNameView()
        layoutInputIntroduceView()
        layoutTaskSelectView()
        layoutPortfolioSelectView()
    }
    
    private func layoutNavBar() {
        self.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func layoutScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.contentView.backgroundColor = .teamOne.background
    }
    
    private func layoutProfileImageView() {
        editProfileImageBackground.backgroundColor = .white
        editProfileImageBackground.addSubview(editProfileImageButton)
        editProfileImageButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        
        scrollView.contentView.addSubview(editProfileImageBackground)
        editProfileImageBackground.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(78)
        }
    }
    
    private func layoutBaseStackView() {
        scrollView.contentView.addSubview(baseStackView)
        baseStackView.snp.makeConstraints {
            $0.top.equalTo(editProfileImageBackground.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func layoutInputNickNameView() {
        inputNickNameView.backgroundColor = .white
        inputNickNameView.addSubview(nickNameHeaderLabel)
        inputNickNameView.addSubview(nickNameTextField)
        
        nickNameHeaderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalToSuperview().offset(24)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameHeaderLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        baseStackView.addArrangedSubview(inputNickNameView)
    }
    
    private func layoutInputIntroduceView() {
        inputIntroduceView.backgroundColor = .white
        inputIntroduceView.addSubview(introduceHeaderLabel)
        inputIntroduceView.addSubview(introduceTextView)
        
        introduceHeaderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalToSuperview().offset(24)
        }
        introduceTextView.snp.makeConstraints {
            $0.top.equalTo(introduceHeaderLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(40)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        baseStackView.addArrangedSubview(inputIntroduceView)
    }
    
    private func layoutTaskSelectView() {
        
        baseStackView.addArrangedSubview(firstTaskSelectView)
        baseStackView.addArrangedSubview(secondTaskSelectView)
    }
    
    private func layoutPortfolioSelectView() {
        baseStackView.addArrangedSubview(portfolioSelectView)
    }
}
