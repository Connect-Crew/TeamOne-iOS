//
//  TitleLayer.swift
//  TeamOne
//
//  Created by 강현준 on 12/2/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import Then
import Core

enum TitleLayerStatus {
    case done
    case none
}

final class TitleLayer: UILabel {

    static let noneColor = UIColor.teamOne.grayscaleFive
    static let doneColor = UIColor.teamOne.mainColor

    var state: TitleLayerStatus = .none {
        didSet {
            setColor()
        }
    }

    func setColor() {
        switch state {
        case .done:
            self.textColor = Self.doneColor
        case .none:
            self.textColor = Self.noneColor
        }
    }
}
