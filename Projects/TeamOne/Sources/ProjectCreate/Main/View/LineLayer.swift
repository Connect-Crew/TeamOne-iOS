//
//  LineLayer.swift
//  TeamOne
//
//  Created by 강현준 on 12/1/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import SnapKit

enum LineLayerStatus {
    case done
    case none
}

final class LineLayer: UIView {

    static let noneColor = UIColor.teamOne.grayscaleFive
    static let doneColor = UIColor.teamOne.mainColor


    var state: LineLayerStatus = .done {
        didSet {
            updateLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.snp.makeConstraints {
            $0.height.equalTo(2)
        }
    }

    func updateLayout() {
        switch state {
        case .done:
            self.backgroundColor = Self.doneColor
        case .none:
            self.backgroundColor = Self.noneColor
        }
    }

}
