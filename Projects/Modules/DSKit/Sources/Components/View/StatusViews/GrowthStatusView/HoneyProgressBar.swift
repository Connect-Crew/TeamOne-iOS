//
//  HoneyProgressBar.swift
//  DSKit
//
//  Created by 강현준 on 2/14/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Core

public final class HoneyProgressBar: RoundableView {
    
    private let progressBarView = RoundableView().then {
        $0.backgroundColor = .levelOneColor
    }
    
    public var ratio: CGFloat = 0.0 {
        didSet {
            updateRatio()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.isUserInteractionEnabled = false
        self.backgroundColor = .grayscaleTwo
        
        addSubview(progressBarView)
        
        progressBarView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(self.ratio)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgressColor(color: UIColor) {
        self.progressBarView.backgroundColor = color
    }
    
    private func updateRatio() {
        progressBarView.isHidden = !self.ratio.isLess(than: 1.0)
        
        progressBarView.snp.remakeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(ratio)
        }
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: self.layoutIfNeeded,
            completion: nil
        )
        
    }
}
