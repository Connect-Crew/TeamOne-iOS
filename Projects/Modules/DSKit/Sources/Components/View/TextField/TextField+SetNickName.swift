//
//  TextField+SetNickName.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

public class TextField_SetNickName: TextField {

    private let underBar: UIView = .init()
    public let button = UIButton()

    var validation: Validation = .none {
        didSet {
            self.underBar.backgroundColor = validation.color
        }
    }

    enum Validation {
        case none
        case valid
        case invalid

        var color: UIColor {
            switch self {
            case .none:
                return UIColor.teamOne.grayscaleEight
            case .invalid:
                return UIColor.teamOne.point
            case .valid:
                return UIColor.teamOne.mainColor
            }
        }
    }

    public init() {
        super.init(frame: .zero)
        setup()
        setupButton()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()

        self.placeholder = "최소 2글자 이상 입력해주세요!"
    }

    func setupButton() {
        button.setButton(image: .closeButtonX)
        button.addTarget(self, action: #selector(clearAction), for: .touchUpInside)

        rightView = button
    }

    @objc func clearAction() {
        self.text = ""
    }
}
