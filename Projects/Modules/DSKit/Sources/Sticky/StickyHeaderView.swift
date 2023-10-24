//
//  StickyHeaderView.swift
//  DSKitTests
//
//  Created by 강현준 on 2023/10/24.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit

open class StickyHeaderView: UIView {

    let headerMaxHeight = 100.0
    let headerMinHeight = 100.0

    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .lightGray
        $0.contentInset = .init(top: self.headerMaxHeight, left: 0, bottom: 0, right: 0)
    }

    private let beforeHeaderView = UIView().then {
        $0.backgroundColor = .blue
    }

    private let afterHeaderView = UIView().then {
        $0.backgroundColor = .yellow
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
    }

    private let label = UILabel().then {
        $0.text = "1long text\n\n\n2long text\n\n\n\n\n3long textlontext\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n4textlongtextlong"
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 36)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        scrollView.delegate = self

        [scrollView, beforeHeaderView, afterHeaderView].forEach { addSubview($0) }

        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(label)

        beforeHeaderView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(80)
        }

        afterHeaderView.snp.makeConstraints {
            $0.top.equalTo(beforeHeaderView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(80)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StickyHeaderView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView.contentOffset.y이 음수인 경우는 스크롤이 시작되지 않았거나 스크롤이 최상단인경우
        // scrollView.contentOffset.y이 N >= 0 스크롤이 내려가는경우
        let remainTopSpacingoffset = -scrollView.contentOffset.y
        let percentage = (remainTopSpacingoffset-80) / 50

        print("remainTopSpacingoffset: \(remainTopSpacingoffset)")
        print("percentage: \(percentage)")


        if remainTopSpacingoffset < headerMinHeight {
            beforeHeaderView.snp.updateConstraints {
                $0.height.equalTo(remainTopSpacingoffset)
            }
        } else {
            beforeHeaderView.snp.updateConstraints {
                $0.height.equalTo(headerMinHeight)
            }
        }

//        beforeHeaderView.alpha = percentage
    }
}
