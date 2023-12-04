//
//  AnnularLayer.swift
//  TeamOne
//
//  Created by 강현준 on 12/1/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit
import DSKit

final class AnnularView: UIView {

    static let defaultStepColor = UIColor.teamOne.grayscaleFive
    static let currentStepColor = UIColor.teamOne.white
    static let finishedStepColor = UIColor.teamOne.mainColor

    static let defaultBackgroundColor = UIColor.clear
    static let currentBackgroundColor = UIColor.teamOne.mainColor
    static let finishBackgroundColor = UIColor.clear

    static let defaultLayerColor = UIColor.teamOne.grayscaleFive.cgColor
    static let currentLayerColor = UIColor.teamOne.mainColor.cgColor
    static let finishLayerColor = UIColor.teamOne.mainColor.cgColor

    let labelStep = UILabel().then {
        $0.setLabel(text: "0", typo: .caption2, color: .teamOne.grayscaleSeven)
    }

    var state: StepIndicatorViewStatus = .none {
        didSet {
            updateLayout()
        }
    }

    // MARK: - Properties

    var step: Int = 0 {
        didSet {
            labelStep.text = "\(step)"
        }
    }

    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.setLayer(width: 1, color: .teamOne.white)

        self.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setRoundCircle()
        layoutStepLabel()
    }

    func updateLayout() {

        switch state {
        case .finish:
            self.backgroundColor = Self.finishBackgroundColor
            self.layer.borderColor = Self.finishLayerColor
            self.labelStep.textColor = Self.finishedStepColor
        case .current:
            self.backgroundColor = Self.currentBackgroundColor
            self.layer.borderColor = Self.currentLayerColor
            self.labelStep.textColor = Self.currentStepColor
        case .none:
            self.backgroundColor = Self.defaultBackgroundColor
            self.layer.borderColor = Self.defaultLayerColor
            self.labelStep.textColor = Self.defaultStepColor
        }
    }

    func layoutStepLabel() {
        addSubview(labelStep)

        labelStep.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
