//
//  ParticipationStatusView.swift
//  DSKit
//
//  Created by 강현준 on 2/13/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import SnapKit
import Then

public final class ParticiPationStatusView: View {
    
    private lazy var contentView = UIStackView(arrangedSubviews: [
        activeStatusView,
        completedStatusView,
        representativeStatusView
    ]).then {
        $0.distribution = .fillEqually
    }
    
    private let firstDivider = UIView().then {
        $0.setDivider(width: 1)
    }
    
    private let secondDivider = UIView().then {
        $0.setDivider(width: 1)
    }
    
    private let activeStatusView = ParticipationStatusSuvView(title: "참가중")
    private let completedStatusView = ParticipationStatusSuvView(title: "참가완료")
    private let representativeStatusView = ParticipationStatusSuvView(title: "대표 프로젝트")
    
    public var activateProjectCount: Int = 0 {
        didSet {
            activeStatusView.countLabel.text = "\(activateProjectCount)"
        }
    }
    
    public var completedProjectCount: Int = 0 {
        didSet {
            completedStatusView.countLabel.text = "\(completedProjectCount)"
        }
    }
    
    public var representativeProjectCount: Int = 0 {
        didSet {
            representativeStatusView.countLabel.text = "\(representativeProjectCount)"
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
        
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(63)
        }
        
        self.backgroundColor = .teamOne.white
        
        self.setBaseShadow(radius: 8)
        self.setRound(radius: 8)
        
        self.addSubview(firstDivider)
        
        firstDivider.snp.makeConstraints {
            $0.leading.equalTo(activeStatusView.snp.trailing)
        }
        
        self.addSubview(secondDivider)
        
        secondDivider.snp.makeConstraints {
            $0.leading.equalTo(completedStatusView.snp.trailing)
        }
        
        [firstDivider, secondDivider].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(47)
                $0.centerY.equalToSuperview()
            }
        }
    }
}
