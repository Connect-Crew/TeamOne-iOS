//
//  RecruitSetPartView.swift
//  DSKit
//
//  Created by 강현준 on 12/16/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core

public struct DSRecurit {
    public var partMajor: String
    public var partSub: String
    public var comment: String
    public var max: Int

    public init(partMajor: String, partSub: String, comment: String, max: Int) {
        self.partMajor = partMajor
        self.partSub = partSub
        self.comment = comment
        self.max = max
    }

    static var remainTeamNumber = 29
}

public final class RecruitSetPartView: UIView {

    public var recruits: [DSRecurit] = [] {
        didSet {
            if recruits.isEmpty {
                self.isHidden = true
            } else {
                self.isHidden = false
            }
            
            rxRecruits.onNext(recruits)
        }
    }

    public var rxRecruits = BehaviorSubject<[DSRecurit]>(value: [])

    private let contentView = UIStackView()
        .then {
            $0.backgroundColor = .clear
            $0.axis = .vertical
            $0.spacing = 18
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        }

    public init() {
        super.init(frame: .zero)

        initLayout()
    }

    public func addRecruits(major: String, sub: String) {

        guard DSRecurit.remainTeamNumber > 1 else { return }

        let recruit = DSRecurit(partMajor: major, partSub: sub, comment: "", max: 1)
        self.recruits.append(recruit)

        let cell = RecruitSetPartCell(recruit: recruit)

        DSRecurit.remainTeamNumber -= 1

        cell.onDelete = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }

            if let index = self.contentView.arrangedSubviews.firstIndex(of: cell) {
                DSRecurit.remainTeamNumber += self.recruits[index].max

                self.contentView.removeArrangedSubview(cell)
                cell.removeFromSuperview()
                self.recruits.remove(at: index)
            }
        }

        cell.onPlus = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }

            if let index = self.contentView.arrangedSubviews.firstIndex(of: cell) {
                if DSRecurit.remainTeamNumber > 0 {
                    self.recruits[index].max += 1
                    DSRecurit.remainTeamNumber -= 1
                    cell.recruit = self.recruits[index]
                }
            }
        }

        cell.onMinus = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }

            if let index = self.contentView.arrangedSubviews.firstIndex(of: cell) {
                if self.recruits[index].max > 1 {
                    self.recruits[index].max -= 1
                    DSRecurit.remainTeamNumber += 1
                    cell.recruit = self.recruits[index]
                }
            }

        }

        cell.onChangeComment = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }

            if let index = self.contentView.arrangedSubviews.firstIndex(of: cell) {
                self.recruits[index].comment = $0
            } }

        self.contentView.addArrangedSubview(cell)
    }

    func initLayout() {
        self.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.backgroundColor = .clear
        contentView.backgroundColor = .clear

        self.setLayer(width: 1, color: .teamOne.grayscaleFive)
        self.setRound(radius: 8)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class RecruitSetPartCell: View {
    let labelMajorPart = UILabel().then {
        $0.setLabel(text: "", typo: .button2, color: .teamOne.grayscaleEight)
    }

    let labelSubPart = UILabel().then {
        $0.setLabel(text: "", typo: .button2, color: .teamOne.grayscaleFive)
    }

    let buttonMinus = UIButton().then {
        $0.setButton(text: "-", typo: .button2, color: .teamOne.grayscaleEight)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
    }

    let buttonCount = UIButton().then {
        $0.setButton(text: "1", typo: .button2, color: .teamOne.grayscaleEight)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
    }

    let buttonPlus = UIButton().then {
        $0.setButton(text: "+", typo: .button2, color: .teamOne.grayscaleEight)
        $0.setLayer(width: 1, color: .teamOne.grayscaleFive)
    }

    let buttonClose = UIButton().then {
        $0.setButton(image: .delete2)
    }

    let textfieldComment = UITextField().then {
        $0.placeholder = "(선택) 설명해주세요"
        $0.textColor = .teamOne.grayscaleFive
    }

    lazy var divider = UIView().then {
        $0.setDivider(height: 1, color: .teamOne.grayscaleFive)
    }

    lazy var firstStackView = UIStackView(arrangedSubviews: [
        makeTitleStackView(),
        makeButtonStackView()
    ])

    lazy var contentView = UIStackView(arrangedSubviews: [
        firstStackView,
        textfieldComment
    ]).then {
        $0.axis = .vertical
    }

    var recruit: DSRecurit! {
        didSet {
            setContent()
        }
    }

    var onDelete: (() -> Void)?

    var onPlus: (() -> Void)?

    var onMinus: (() -> Void)?

    var onChangeComment: ((String) -> Void)?

    public init(recruit: DSRecurit) {

        super.init(frame: .zero)

        self.recruit = recruit

        initLayout()
        bind()
        setContent()
    }

    func initLayout() {

        self.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.addSubview(divider)

        divider.snp.makeConstraints {
            $0.top.equalTo(textfieldComment.snp.bottom)
            $0.leading.trailing.equalTo(textfieldComment)
        }

    }

    func setContent() {
        self.labelMajorPart.text = recruit.partMajor
        self.labelSubPart.text = recruit.partSub
        self.buttonCount.setTitle("\(recruit.max)", for: .normal)
    }

    func bind() {
        textfieldComment.rx.text.orEmpty
            .subscribe(onNext: { [weak self] content in
                self?.recruit.comment = content

                self?.onChangeComment?(content)
            })
            .disposed(by: disposeBag)

        buttonPlus.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.onPlus?()
            })
            .disposed(by: disposeBag)

        buttonMinus.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.onMinus?()
            })
            .disposed(by: disposeBag)

        buttonClose.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.onDelete?()
            })
            .disposed(by: disposeBag)

    }

    func makeTitleStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            labelMajorPart,
            labelSubPart,
            UIView()
        ]).then {
            $0.spacing = 10
        }
    }

    func makeButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [
            buttonMinus,
            buttonCount,
            buttonPlus,
            buttonClose
        ]).then {
            $0.setCustomSpacing(10, after: buttonPlus)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

