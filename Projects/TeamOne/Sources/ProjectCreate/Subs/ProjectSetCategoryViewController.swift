//
//  ProjectSetCategoryViewController.swift
//  TeamOne
//
//  Created by 강현준 on 12/8/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxCocoa
import Then
import DSKit
import Domain

final class ProjectSetCategoryViewController: ViewController {

    let scrollView = BaseScrollView()

    let labelCategoryTitle = UILabel().then {
        $0.setLabel(text: "프로젝트 분야가 무엇인가요?", typo: .body2, color: .teamOne.grayscaleEight)
    }

    let labelCategoryContentOne = UILabel().then {
        $0.setLabel(text: "모집 화면에 태그가 생성되어 더욱 눈에 뛸 수 있어요!", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let labelCategoryContentTwo = UILabel().then {
        $0.setLabel(text: "최대 3개까지 선택할 수 있어요!", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    let labelCategoryContentPoint = UILabel().then {
        $0.setLabel(text: "(최소 1개 선택)", typo: .caption2, color: .teamOne.point)
    }

    var categoryViewArray: [ProjectCreateCategoryView] = []

    lazy var contentHorizontalStackView = UIStackView(arrangedSubviews: [
        labelCategoryContentTwo,
        labelCategoryContentPoint,
        UIView()
    ])

    lazy var contentView = UIStackView(arrangedSubviews: [
        labelCategoryTitle,
        labelCategoryContentOne,
        contentHorizontalStackView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.layoutMargins = UIEdgeInsets(top: 25, left: 24, bottom: 10, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.setCustomSpacing(10, after: labelCategoryTitle)
        $0.setCustomSpacing(0, after: labelCategoryContentOne)
    }

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

    var categoryTapSubject = PublishSubject<String>()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setCategory()
        layoutCategory()
        view.backgroundColor = .white
    }

    func bind(output: ProjectCreateMainViewModel.Output) {
        output
            .selectedCategory
            .drive(onNext: { [weak self] selected in
                guard let self = self else { return }

                for view in self.categoryViewArray {
                    if selected.contains(where: { $0 == view.categoryTitle }) {
                        view.isSelected = true
                    } else {
                        view.isSelected = false
                    }
                }

            })
            .disposed(by: disposeBag)

        output.selectedCategory
            .map { !$0.isEmpty }
            .drive(buttonNext.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    // MARK: - Layout

    override func layout() {

        self.view.addSubview(scrollView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.contentView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.view.addSubview(buttonStackView)

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func setCategory() {
        for category in ProjectCreateCategoryList.allCases {
            let categoryView = ProjectCreateCategoryView()
            categoryView.isSelected = false
            categoryView.categoryTitle = category.title
            categoryView.categoryImgae = category.image
            categoryView.selectedBGColor = category.selectedBackgroundColor
            categoryView.selectedLayerColor = category.selectedLayerColor
            categoryView.selectedTitleColor = UIColor(cgColor: category.selectedLayerColor)

            categoryViewArray.append(categoryView)

            categoryView.snp.makeConstraints {
                $0.height.equalTo(categoryView.snp.width)
            }

            categoryView.backgroundButton.rx.tap
                .map { categoryView.categoryTitle }
                .bind(to: categoryTapSubject)
                .disposed(by: disposeBag)
        }
    }

    func layoutCategory() {

        var currentStackView = makeStackView()

        for idx in 0..<categoryViewArray.count {
            if idx % 3 == 0 {
                contentView.addArrangedSubview(currentStackView)
                currentStackView = makeStackView()
            }

            currentStackView.addArrangedSubview(categoryViewArray[idx])
        }

        contentView.addArrangedSubview(currentStackView)
    }

    func makeStackView() -> UIStackView {
        return UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.distribution = .fillEqually
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonStackView.frame.height, right: 0)
    }
}
