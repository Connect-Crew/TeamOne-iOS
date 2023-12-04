//
//  CellListStackView.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/28.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import SnapKit
import UIKit
import Then
import Core
import RxSwift
import RxCocoa

public extension Reactive where Base: CellListStackView {
    var list: Binder<[String]> {
        return Binder(self.base) { view, list in
            view.addTags(list)
        }
    }
}

public final class CellListStackView: UIView {

    private var tags: [String] = [] // 이 배열에 태그를 저장
    private let horizontalStackSpacing: CGFloat = 8.0 // 수평 스택 뷰 간격
    private let verticalStackSpacing: CGFloat = 8.0 // 수직 스택 뷰 간격

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = verticalStackSpacing
        stackView.alignment = .leading
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func addTags(_ tags: [String]) {
        self.tags = tags
        layoutSubviews()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutTags()
    }

    private func layoutTags() {
        // Clear existing tags
            verticalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            var currentStackView = createHorizontalStackView()
            verticalStackView.addArrangedSubview(currentStackView)

            var currentLineWidth: CGFloat = 0 // 현재 라인의 너비

            for tag in tags {
                let tagLabel = createTagLabel(withText: tag)
                tagLabel.sizeToFit()

                // 레이블을 추가할 때 예상되는 라인 너비를 계산
                let tagLabelWidth = tagLabel.intrinsicContentSize.width + horizontalStackSpacing
                let expectedLineWidth = currentLineWidth + tagLabelWidth

                // 크기가 넘어간다면 새로운 스택뷰
                if expectedLineWidth > self.frame.width - (horizontalStackSpacing * 2) { // 여백 고려
                    currentStackView = createHorizontalStackView()
                    verticalStackView.addArrangedSubview(currentStackView)
                    currentLineWidth = 0
                }

                currentStackView.addArrangedSubview(tagLabel)
                currentLineWidth += tagLabelWidth
            }
        
        verticalStackView.arrangedSubviews.forEach { view in
            if let stackView = view as? UIStackView {
                stackView.addArrangedSubview(UIView())
            }
        }
    }

    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = horizontalStackSpacing
        stackView.alignment = .center

        return stackView
    }

    private func createTagLabel(withText text: String) -> PaddingLabel {
        let label = PaddingLabel()
        label.setLabel(text: text, typo: .caption1, color: .teamOne.mainColor)
        label.textAlignment = .center
        label.backgroundColor = .clear // 태그의 배경색 설정
        label.setRound(radius: 13)
        label.layer.borderColor = UIColor.teamOne.mainColor.cgColor
        label.layer.borderWidth = 1
        label.textInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)

        return label
    }
}
