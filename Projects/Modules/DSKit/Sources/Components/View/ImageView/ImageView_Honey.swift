//
//  ImageView_Honey.swift
//  DSKit
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

/// 프로젝트에 사용되는 꿀통 ImageView입니다.
/// 생성 후 setHoney 메서드를 호출해야 이미지가 세팅됩니다.
/// 생성자에 지정한 크기대로 컴포넌트의 크기가 설정됩니다.
/// 크기에 대한 오토레이아웃을 따로 지정하지 않아도 됩니다.
public final class ImageView_Honey: UIImageView {
    
    public enum HoneyType {
        case small
        case large
        
        static func setLevel(temparature: Double?) -> Int {
            return 1
        }
    }
    
    public enum HoneySmallType {
        case one
        case two
        case three
        case four
        
        var honeyImage: UIImage? {
            switch self {
            case .one:
                return .image(dsimage: .honeySmall1)
            case .two:
                return .image(dsimage: .honeySmall2)
            case .three:
                return .image(dsimage: .honeySmall3)
            case .four:
                return .image(dsimage: .honeySmall4)
            }
        }
        
        init(temparature: Double?) {
            let level = HoneyType.setLevel(temparature: temparature)
            
            switch level {
            case 1:
                self = .one
            case 2:
                self = .two
            case 3:
                self = .three
            case 4:
                self = .four
            default:
                fatalError()
            }
        }
    }
    
    public enum HoneyLargeType {
        case one
        case two
        case three
        case four
        
        var honeyImage: UIImage? {
            switch self {
            case .one:
                return .image(dsimage: .honeyLarge1)
            case .two:
                return .image(dsimage: .honeyLarge2)
            case .three:
                return .image(dsimage: .honeyLarge3)
            case .four:
                return .image(dsimage: .honeyLarge4)
            }
        }
        
        init(temparature: Double?) {
            let level = HoneyType.setLevel(temparature: temparature)
            
            switch level {
            case 1:
                self = .one
            case 2:
                self = .two
            case 3:
                self = .three
            case 4:
                self = .four
            default:
                fatalError()
            }
        }
    }
    
    private let type: HoneyType
    private var temparature: Double?
    
    /// 꿀통 이미지뷰를 생성하는 생성자입니다.
    /// type은 large, small 두 가지가 있습니다.
    /// type은 피그마에 해당 컴포넌트를 클릭하면 나타납니다.
    public init(type: HoneyType) {
        self.type = type
        super.init(frame: .zero)
        
        setHoney(temparature: 36.5)
    }
    
    public func setHoney(temparature: Double?) {
        
        self.temparature = temparature
        
        switch type {
        case .small:
            setSmallImage()
        case .large:
            setLargeImage()
        }
    }
    
    private func setSmallImage() {
        let type = HoneySmallType.init(temparature: temparature)
        self.image = type.honeyImage
    }
    
    private func setLargeImage() {
        let type = HoneyLargeType.init(temparature: temparature)
        self.image = type.honeyImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
