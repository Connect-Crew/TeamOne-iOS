//
//  ImageView_Honey.swift
//  DSKit
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

/// 프로젝트에 사용되는 꿀통 ImageView입니다.
/// 크기에 대한 오토레이아웃을 따로 지정하지 않아도 됩니다.
public final class ImageView_Honey: UIImageView {
    
    public enum HoneyLevel {
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        
        var image: UIImage? {
            switch self {
            case .one: return .image(dsimage: .lv1)
            case .two: return .image(dsimage: .lv2)
            case .three: return .image(dsimage: .lv3)
            case .four: return .image(dsimage: .lv4)
            case .five: return .image(dsimage: .lv5)
            case .six: return .image(dsimage: .lv6)
            case .seven: return .image(dsimage: .lv7)
            }
        }
        
        static func toLevel(temparature: Double?) -> HoneyLevel {
            return .one
        }
    }
    
    private var type: HoneyLevel = .one {
        didSet {
            self.image = type.image
        }
    }
    
    public init() {
        super.init(frame: .zero)
        initLayout()
        self.image = type.image
    }
    
    public func setHoney(temparature: Double?) {
        self.type = HoneyLevel.toLevel(temparature: temparature)
    }
    
    private func initLayout() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
