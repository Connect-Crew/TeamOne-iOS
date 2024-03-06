//
//  Portfolio.swift
//  TeamOne
//
//  Created by 강창혁 on 2/25/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Core
import RxSwift
import RxCocoa
import SnapKit
import Then

final class PortfolioSelectView: View {
    
    private lazy var baseStackView = UIStackView(
        arrangedSubviews: [linkHeaderView, linkContentView, fileHeaderView, fileContentView]
    ).then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    // MARK: - 헤더
    
    private let headerLabel = UILabel().then {
        $0.setLabel(text: "포트폴리오", typo: .body4, color: .black)
    }
    
    // MARK: - 링크 헤더
    
    private let linkHeaderView = UIView()
    
    private let linkImageView = UIImageView().then {
        $0.image = .image(dsimage: .chain)
    }
    
    private let linkHeaderLabel = UILabel().then {
        $0.setLabel(text: "링크", typo: .button2, color: .grayscaleSeven)
    }
    
    private let linkContentExpandableImageView = UIImageView().then {
        $0.image = .image(dsimage: .down)
    }
    
    private lazy var horizonalDivider = UIView().then {
        $0.setDivider(height: 1, width: self.frame.width, color: .grayscaleTwo)
    }
    
    private let linkContentExpandableButton = UIButton()
    
    // MARK: - 링크 컨텐츠
    
    private let linkContentView = UIView().then {
        $0.isHidden = true
    }
    
    private lazy var contentsStackView = UIStackView(arrangedSubviews: [warningLabelView, linkInputView, portfolioCompleteView]).then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private let linkUploadWarningImage = UIImageView().then {
        $0.image = .image(dsimage: .warning)
    }
    
    private let linkUploadWarningLabel = UILabel().then {
        $0.setLabel(text: "링크는 한 개만 업로드 가능합니다.", typo: .caption2, color: .red)
    }
    
    private let warningLabelView = UIView()
    
    private let linkInputView = PortfolioLinkInputView()
    
    private let portfolioCompleteView = PortfolioView(type: .link).then {
        $0.isHidden = true
    }
    
    // MARK: - 파일 헤더
    
    private let fileHeaderView = UIView()
    
    private let fileImageView = UIImageView().then {
        $0.image = .image(dsimage: .file)
    }
    
    private let fileHeaderLabel = UILabel().then {
        $0.setLabel(text: "파일", typo: .button2, color: .grayscaleSeven)
    }
    
    private let fileContentExpandableImageView = UIImageView().then {
        $0.image = .image(dsimage: .down)
    }
    
    private lazy var fileHorizonalDivider = UIView().then {
        $0.setDivider(height: 1, width: self.frame.width, color: .grayscaleTwo)
    }
    
    private let fileContentExpandableButton = UIButton()
    
    // MARK: - 파일 컨텐츠
    
    private let fileContentView = UIView().then {
        $0.isHidden = true
    }
    
    private lazy var fileContentsStackView = UIStackView(arrangedSubviews: [
        fileWarningLabelView,
        firstFileInputView,
        firstFilePortfolioCompleteView,
        secondFileInputView,
        secondFilePortfolioCompleteView,
        thirdFileInputView,
        thridFilePortfolioCompleteView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private let fileUploadWarningImage = UIImageView().then {
        $0.image = .image(dsimage: .warning)
    }
    
    private let fileUploadWarningLabel = UILabel().then {
        $0.setLabel(text: "파일은 최대 3개, 총 15MB 미만의 PDF 파일만 업로드 가능합니다.", typo: .caption2, color: .red)
    }
    
    private let fileWarningLabelView = UIView()
    
    let firstFileInputView = PortfolioFileInputView()
    
    let firstFilePortfolioCompleteView = PortfolioView(type: .file).then {
        $0.isHidden = true
    }
    
    let secondFileInputView = PortfolioFileInputView().then {
        $0.isHidden = true
    }
    
    let secondFilePortfolioCompleteView = PortfolioView(type: .file).then {
        $0.isHidden = true
    }
    
    let thirdFileInputView = PortfolioFileInputView().then {
        $0.isHidden = true
    }
    
    let thridFilePortfolioCompleteView = PortfolioView(type: .file).then {
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        bindLinkContentExpandableButton()
        bindLinkInputView()
        bindPortfolioCompleteView()
        bindFileContentExpandableButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(baseStackView)
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        configureLinkHeaderViewLayout()
        configureLinkContentViewLayout()
        configureFileHeaderViewLayout()
        configureFileContentViewLayout()
    }
    
    private func configureLinkHeaderViewLayout() {
        linkHeaderView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(24)
        }
        
        linkHeaderView.addSubview(linkImageView)
        linkImageView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(26)
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalToSuperview().inset(24)
        }
        
        linkHeaderView.addSubview(linkHeaderLabel)
        linkHeaderLabel.snp.makeConstraints {
            $0.centerY.equalTo(linkImageView)
            $0.leading.equalTo(linkImageView.snp.trailing).offset(8)
        }
        
        linkHeaderView.addSubview(linkContentExpandableImageView)
        linkContentExpandableImageView.snp.makeConstraints {
            $0.centerY.equalTo(linkImageView)
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.trailing.equalToSuperview().inset(24)
        }
        linkHeaderView.addSubview(horizonalDivider)
        horizonalDivider.snp.makeConstraints {
            $0.top.equalTo(linkImageView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        linkHeaderView.addSubview(linkContentExpandableButton)
        linkContentExpandableButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureLinkContentViewLayout() {
        linkContentView.addSubview(contentsStackView)
        contentsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        warningLabelView.addSubview(linkUploadWarningImage)
        linkUploadWarningImage.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(2)
            $0.size.equalTo(CGSize(width: 12, height: 12))
        }
        warningLabelView.addSubview(linkUploadWarningLabel)
        linkUploadWarningLabel.snp.makeConstraints {
            $0.leading.equalTo(linkUploadWarningImage.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureFileHeaderViewLayout() {
        fileHeaderView.addSubview(fileImageView)
        fileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.leading.equalToSuperview().inset(24)
        }
        
        fileHeaderView.addSubview(fileHeaderLabel)
        fileHeaderLabel.snp.makeConstraints {
            $0.centerY.equalTo(fileImageView)
            $0.leading.equalTo(fileImageView.snp.trailing).offset(8)
        }
        
        fileHeaderView.addSubview(fileContentExpandableImageView)
        fileContentExpandableImageView.snp.makeConstraints {
            $0.centerY.equalTo(fileImageView)
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.trailing.equalToSuperview().inset(24)
        }
        fileHeaderView.addSubview(fileHorizonalDivider)
        fileHorizonalDivider.snp.makeConstraints {
            $0.top.equalTo(fileImageView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        fileHeaderView.addSubview(fileContentExpandableButton)
        fileContentExpandableButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureFileContentViewLayout() {
        fileContentView.addSubview(fileContentsStackView)
        fileContentsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        fileWarningLabelView.addSubview(fileUploadWarningImage)
        fileUploadWarningImage.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(2)
            $0.size.equalTo(CGSize(width: 12, height: 12))
        }
        fileWarningLabelView.addSubview(fileUploadWarningLabel)
        fileUploadWarningLabel.snp.makeConstraints {
            $0.leading.equalTo(fileUploadWarningImage.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func bindLinkContentExpandableButton() {
        linkContentExpandableButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                guard this.linkContentView.isHidden else {
                    this.linkContentExpandableImageView.image = .image(dsimage: .down)
                    this.linkContentView.isHidden = true
                    return
                }
                this.linkContentExpandableImageView.image = .image(dsimage: .up)
                this.linkContentView.isHidden = false
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindFileContentExpandableButton() {
        fileContentExpandableButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                guard this.fileContentView.isHidden else {
                    this.fileContentExpandableImageView.image = .image(dsimage: .down)
                    this.fileContentView.isHidden = true
                    return
                }
                this.fileContentExpandableImageView.image = .image(dsimage: .up)
                this.fileContentView.isHidden = false
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindLinkInputView() {
        
        let portfolioLinkName = linkInputView.nameInputView.nameTextField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .map { this, _ in
                this.linkInputView.nameInputView.nameTextField.text
            }
        
        let portfolioURL = linkInputView.URLInputView.linkURLTextfield.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .map { this, _ in
                this.linkInputView.URLInputView.linkURLTextfield.text
            }
        
        portfolioURL.withLatestFrom(portfolioLinkName)
            .withUnretained(self)
            .bind { this, url in
                let linkName = this.linkInputView.nameInputView.nameTextField.text
                
                if url != "", linkName != "" {
                    this.linkInputView.isHidden = true
                    this.portfolioCompleteView.isHidden = false
                    this.portfolioCompleteView.linkNameLabel.text = linkName
                    this.portfolioCompleteView.linkAdressLabel.text = url
                } else {
                    this.linkImageView.isHidden = false
                    this.portfolioCompleteView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        portfolioLinkName.withLatestFrom(portfolioURL)
            .withUnretained(self)
            .bind { this, url in
                let linkName = this.linkInputView.nameInputView.nameTextField.text
                
                if url != "", linkName != "" {
                    this.linkInputView.isHidden = true
                    this.portfolioCompleteView.isHidden = false
                    this.portfolioCompleteView.linkNameLabel.text = linkName
                    this.portfolioCompleteView.linkAdressLabel.text = url
                } else {
                    this.linkImageView.isHidden = false
                    this.portfolioCompleteView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindPortfolioFileNameReceived() {
        
    }
    
    private func bindPortfolioCompleteView() {
        
        portfolioCompleteView.deleteButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.portfolioCompleteView.isHidden = true
                this.linkInputView.isHidden = false
                this.linkInputView.nameInputView.nameTextField.text = nil
                this.linkInputView.URLInputView.linkURLTextfield.text = nil
            }
            .disposed(by: disposeBag)
    }
}
