//
//  Button+IsLikedOnlyImage.swift
//  DSKit
//
//  Created by 강현준 on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

public class Button_IsLikedOnlyImage: UIButton {
    
    static let likedImage: UIImage? = .image(dsimage: .heartsolid)
    static let unLikedImage: UIImage? = .image(dsimage: .heartline)
    
    public var isLiked: Bool {
        didSet {
            if isLiked {
                self.setImage(Self.likedImage, for: .normal)
            } else {
                self.setImage(Self.unLikedImage, for: .normal)
            }
        }
    }
    
    public init(isLiked: Bool) {
        self.isLiked = isLiked
        super.init(frame: .zero)
        
        let image = isLiked ? Self.likedImage : Self.unLikedImage
        self.setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

