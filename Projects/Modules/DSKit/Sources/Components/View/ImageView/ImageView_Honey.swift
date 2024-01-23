//
//  ImageView_Honey.swift
//  DSKit
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

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
