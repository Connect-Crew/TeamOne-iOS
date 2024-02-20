//
//  Button+ViewPortfolio.swift
//  DSKit
//
//  Created by 강현준 on 2/20/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

public final class Button_ViewPortfolio: UIView {
    
    private let titleLabel = UILabel().then {
        $0.setLabel(text: "포트폴리오 바로가기", typo: .button2, color: .mainColor)
    }
    
    private let imageView = UIImageView().then {
        $0.image = .image(dsimage: .arrowRightBlue)
    }
    
    private lazy var contentView = UIStackView(arrangedSubviews: [
            titleLabel,
            imageView
        
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 19, left: 20, bottom: 19, right: 20)
        $0.alignment = .center
        $0.spacing = 5
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    internal let backgroundButton = UIButton()
    
    public override var isHidden: Bool {
        didSet{
            self.contentView.isHidden = true
        }
    }
    
    public init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        addSubview(backgroundButton)
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.backgroundColor = .mainlightColor
        self.setRound(radius: 8)
        self.setLayer(width: 1, color: .mainColor)
    }
}

public extension Reactive where Base: Button_ViewPortfolio {
    var tap: ControlEvent<Void> {
        return base.backgroundButton.rx.tap
    }
}
