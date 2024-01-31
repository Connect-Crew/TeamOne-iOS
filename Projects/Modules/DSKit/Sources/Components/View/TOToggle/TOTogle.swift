//
//  TOTogle.swift
//  DSKit
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core

/// This is custom toggle switch class used in the project.
public class TOTogle: View {
    
    private struct Constraint {
        static let buttonSizeToBarRatio: CGFloat = 0.75
        static let togleDuration: CGFloat = 0.25
    }
    
    /**
     Totogle의 타입입니다. Figma에 type이 나와있습니다.
     */
    public enum TOTogleType {
        case large
        case small
        
        var barWidth: CGFloat {
            switch self {
            case .large: return 40
            case .small: return 32
            }
        }
        
        var barHeight: CGFloat {
            switch self {
            case .large: return 20
            case .small: return 16
            }
        }
    }
    
    private let barView = RoundableView().then {
        $0.backgroundColor = .teamOne.grayscaleFive
    }
    
    private let circleView = RoundableView().then {
        $0.backgroundColor = .teamOne.white
    }
    
    private let type: TOTogleType
    
    public var barColor: UIColor = .teamOne.grayscaleFive
    
    public var barTintColor: UIColor = .teamOne.mainColor
    
    public var circleColor: UIColor = .teamOne.white {
        didSet {
            circleView.backgroundColor = circleColor
        }
    }
    
    private let backgroundButton = UIButton().then {
        $0.isEnabled = true
    }
    
    internal let tapSubject = PublishRelay<Void>()
    
    public var rx_isOn = PublishRelay<Bool>()
    
    public var isOn: Bool = false {
        didSet {
            updateToggle()
            rx_isOn.accept(isOn)
        }
    }
    
    /**
     - Parameters:
        - type : type of TOTogle.
        - isOn : isOn
     */
    public init(type: TOTogleType, isOn: Bool = false) {
        self.type = type
        self.isOn = isOn
        
        super.init(frame: .zero)
        initLayout()
        bind()
    }
    
    private func initLayout() {
        
        self.snp.makeConstraints {
            $0.width.equalTo(type.barWidth)
            $0.height.equalTo(type.barHeight)
        }
        
        addSubview(barView)
        
        barView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        barView.addSubview(circleView)
        
        circleView.snp.makeConstraints {
            $0.height.equalTo(type.barHeight * Constraint.buttonSizeToBarRatio)
            $0.width.equalTo(type.barHeight * Constraint.buttonSizeToBarRatio)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(2)
        }
        
        addSubview(backgroundButton)
        
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateToggle() {
        UIView.animate(
            withDuration: Constraint.togleDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                
                guard let self = self else { return }
                
                self.barView.backgroundColor = isOn ? barTintColor : barColor
                
                if isOn {
                    circleView.snp.remakeConstraints {
                        $0.height.equalTo(self.type.barHeight * Constraint.buttonSizeToBarRatio)
                        $0.width.equalTo(self.type.barHeight * Constraint.buttonSizeToBarRatio)
                        $0.centerY.equalToSuperview()
                        $0.trailing.equalToSuperview().inset(2)
                    }
                } else {
                    circleView.snp.remakeConstraints {
                        $0.height.equalTo(self.type.barHeight * Constraint.buttonSizeToBarRatio)
                        $0.width.equalTo(self.type.barHeight * Constraint.buttonSizeToBarRatio)
                        $0.centerY.equalToSuperview()
                        $0.leading.equalToSuperview().offset(2)
                    }
                }
                
                layoutIfNeeded()
            }
        )
    }
    
    private func bind() {
        backgroundButton.rx.tap
            .bind(to: tapSubject)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

