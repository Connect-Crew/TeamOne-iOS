//
//  Button+IsSelected.swift
//  DSKit
//
//  Created by 강현준 on 12/2/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

public class Button_IsSelected: UIButton {

    public var selectedBGColor: UIColor? = .teamOne.mainlightColor
    public var noneSelectedBGColor: UIColor? = .teamOne.grayscaleTwo

    public var selectedLayerColor: CGColor? = UIColor.teamOne.mainColor.cgColor
    public var noneSelectedLayerColor: CGColor? = UIColor.clear.cgColor

    public var selectedTextColor: UIColor? = .teamOne.mainColor
    public var noneSelectedTextColor: UIColor? = .teamOne.grayscaleFive

    public override var isSelected: Bool {
        didSet {
            self.setLayout()
        }
    }

    public init() {
        super.init(frame: .zero)

        self.setRound(radius: 8)
        self.setFont(typo: .button2)
        self.setLayer(width: 1, color: .black)
        self.isEnabled = true
        self.setLayout()
        self.snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        if isSelected {
            self.backgroundColor = selectedBGColor
            self.layer.borderColor = selectedLayerColor
            self.setTitleColor(selectedTextColor, for: .selected)
        } else {
            self.backgroundColor = noneSelectedBGColor
            self.layer.borderColor = noneSelectedLayerColor
            self.setTitleColor(noneSelectedTextColor, for: .normal)
        }
    }
}
