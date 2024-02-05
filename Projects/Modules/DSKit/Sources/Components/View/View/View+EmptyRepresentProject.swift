//
//  View+EmptyRepresentProject.swift
//  DSKit
//
//  Created by 강현준 on 1/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit

public class View_EmptyRepresentProject: UIView {
    
    public let emtpyLabel = UILabel().then {
        $0.setLabel(text: "대표 프로젝트가 아직 없습니다.", typo: .caption2, color: .teamOne.grayscaleSeven)
        $0.textAlignment = .center
    }
    
    public init() {
        
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.setRound(radius: 4)
        self.backgroundColor = .teamOne.grayscaleTwo
        
        self.addSubview(emtpyLabel)
        
        emtpyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
