//
//  SetRecruitTableViewCell.swift
//  TeamOne
//
//  Created by 강현준 on 1/16/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then
import DSKit
import Domain
import Core

final class RecruitSetPartCell: UITableViewCell, CellIdentifiable {
    
    public var disposeBag = DisposeBag()
    
    private let labelMajorPart = UILabel().then {
        $0.setLabel(text: "", typo: .button2, color: .teamOne.grayscaleEight)
    }

    private let labelSubPart = UILabel().then {
        $0.setLabel(text: "", typo: .button2, color: .teamOne.grayscaleFive)
    }

    private let buttonMinus = UIButton().then {
        $0.setButton(text: "-", typo: .button2, color: .teamOne.grayscaleEight)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
    }

    private let buttonCount = UIButton().then {
        $0.setButton(text: "1", typo: .button2, color: .teamOne.grayscaleEight)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
    }

    private let buttonPlus = UIButton().then {
        $0.setButton(text: "+", typo: .button2, color: .teamOne.grayscaleEight)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
    }

    private let buttonDelete = UIButton().then {
        $0.setButton(image: .delete2)
    }

    private lazy var textfieldComment = UITextField().then {
        $0.placeholder = "(선택) 설명해주세요"
        $0.textColor = .teamOne.grayscaleFive
        $0.snp.makeConstraints {
            $0.height.equalTo(26)
        }
        $0.delegate = self
    }

    private lazy var divider = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleFive)
    }

    private lazy var firstStackView = UIStackView(arrangedSubviews: [
        makeTitleStackView(),
        makeButtonStackView()
    ])

    private lazy var contentStackView = UIStackView(arrangedSubviews: [
        firstStackView,
        textfieldComment
    ]).then {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(
            top: 12,
            left: 24,
            bottom: 12,
            right: 24
        )
    }

    var recruit: Recruit?

    var onDelete: ((Recruit) -> Void)?

    var onPlus: ((Recruit) -> Void)?

    var onMinus: ((Recruit) -> Void)?

    var onChangeComment: ((Recruit, String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
        bind()
    }

    private func initLayout() {

        self.contentView.addSubview(contentStackView)

        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.contentView.addSubview(divider)

        divider.snp.makeConstraints {
            $0.top.equalTo(textfieldComment.snp.bottom)
            $0.leading.trailing.equalTo(textfieldComment)
        }

        self.selectionStyle = .none
        
    }

    func initSetting(recruit: Recruit) {
        self.recruit = recruit
        self.labelMajorPart.text = recruit.category
        self.labelSubPart.text = recruit.part
        self.textfieldComment.text = recruit.comment
        self.buttonCount.setTitle("\(recruit.max)", for: .normal)
    }

    func bind() {
        
        buttonPlus.addTarget(self, action: #selector(plusAction), for: .touchUpInside)
        buttonMinus.addTarget(self, action: #selector(minusAction), for: .touchUpInside)
        buttonDelete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)

    }
    
    @objc private  func plusAction() {
        guard let recruit = self.recruit else { return }
        self.onPlus?(recruit)
    }
    
    @objc private  func minusAction() {
        guard let recruit = self.recruit else { return }
        self.onMinus?(recruit)
    }
    
    @objc private  func deleteAction() {
        guard let recruit = self.recruit else { return }
        self.onDelete?(recruit)
    }

    private func makeTitleStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelMajorPart,
            labelSubPart,
            UIView()
        ]).then {
            $0.spacing = 10
        }
    }

    private func makeButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            buttonMinus,
            buttonCount,
            buttonPlus,
            buttonDelete
        ]).then {
            $0.setCustomSpacing(10, after: buttonPlus)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecruitSetPartCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let recruit = self.recruit else { return }
        
        let comment = textField.text ?? ""
        
        onChangeComment?(recruit, comment)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let recruit = self.recruit else { return true }
        
        let comment = textField.text ?? ""
        
        onChangeComment?(recruit, comment)
        
        return true
    }
}
