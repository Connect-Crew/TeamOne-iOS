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
    
    public enum HoneyLevel: Int {
        case one = 1
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
        
        static func expToLevel(exp: Int) -> HoneyLevel {
            switch exp {
            case 0...8: return .one
            case 9...17: return .two
            case 18...34: return .three
            case 45...50: return .four
            case 51...85: return .five
            case 86...114: return .six
            case 144...Int.max: return .seven
            default: return .one
            }
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
    
    public func setLevel(exp: Int) {
        self.type = HoneyLevel.expToLevel(exp: exp)
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
