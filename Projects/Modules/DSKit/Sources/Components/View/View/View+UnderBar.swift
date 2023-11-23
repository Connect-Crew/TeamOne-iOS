//
//  View+UnderBar.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class View_UnderBar: UIView {

    public var validation: View_UnderBar.Validation = .none {
        didSet {
            self.backgroundColor = validation.color
        }
    }

    public enum Validation {
        case none
        case invalid
        case valid

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

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        self.setDivider(height: 1, color: UIColor.teamOne.grayscaleEight)
    }
}
