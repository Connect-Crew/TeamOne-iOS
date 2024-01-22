//
//  PHAssetToUIImage.swift
//  Core
//
//  Created by 강현준 on 1/17/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Photos
import UIKit

extension PHAsset {
    public func toUIImage() -> UIImage? {

        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        
        option.isSynchronous = false
        option.isNetworkAccessAllowed = true
        option.version = .current
        option.deliveryMode = .opportunistic
        option.resizeMode = .fast
        
        var thumbnail:UIImage? = nil
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result
        })
        
        return thumbnail
    }
}
