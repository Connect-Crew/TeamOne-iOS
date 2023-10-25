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

    // before과 after의 높이를 각 각 100으로 설정한 경우의 예시 수치
    // 최대높이는 Beforeheight + Afterheight
    // 최소높이는 Afterheight
//    lazy var headerMaxHeight = 200.0
//    lazy var headerMinHeight = 100.0

    var headerMaxHeight: CGFloat {
        return beforeHeaderViewInitHeight + afterHeaderViewInitHeight
    }

    var headerMinHeight: CGFloat {
        return afterHeaderViewInitHeight
    }

    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .lightGray
        $0.contentInset = .init(top: self.headerMaxHeight, left: 0, bottom: 0, right: 0)
    }

    private let beforeHeaderViewInitHeight: CGFloat

    private let afterHeaderViewInitHeight: CGFloat

    private let beforeHeaderView: UIView

    private let afterHeaderView: UIView

    private let stackView = UIStackView().then {
        $0.axis = .vertical
    }

    private let label = UILabel().then {
        $0.text = "1long text\n\n\n2long text\n\n\n\n\n3long textlontext\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n4textlongtextlong"
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 36)
    }

    public init(beforeHeaderView: UIView, afterHeaderView: UIView, beforeHeaderViewInitHeight: CGFloat, afterHeaderViewInitHeight: CGFloat) {

        self.beforeHeaderView = beforeHeaderView
        self.afterHeaderView = afterHeaderView
        self.beforeHeaderViewInitHeight = beforeHeaderViewInitHeight
        self.afterHeaderViewInitHeight = afterHeaderViewInitHeight

        super.init(frame: .zero)

        scrollView.delegate = self

        [scrollView, beforeHeaderView, afterHeaderView].forEach { addSubview($0) }

        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(label)

        beforeHeaderView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(beforeHeaderViewInitHeight)
        }

        afterHeaderView.snp.makeConstraints {
            $0.top.equalTo(beforeHeaderView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(afterHeaderViewInitHeight)
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
        let remainTopSpacingoffset = -scrollView.contentOffset.y - headerMinHeight

        print("remainTopSpacingoffset: \(remainTopSpacingoffset)")

        print("headerMinHeight: \(headerMinHeight)")
        print("headerMaxHeight: \(headerMaxHeight)")

        if remainTopSpacingoffset < headerMaxHeight {
            beforeHeaderView.snp.updateConstraints {
                $0.height.equalTo(remainTopSpacingoffset)
            }
        } else {
            beforeHeaderView.snp.updateConstraints {
                $0.height.equalTo(remainTopSpacingoffset)
            }
        }
    }
}
