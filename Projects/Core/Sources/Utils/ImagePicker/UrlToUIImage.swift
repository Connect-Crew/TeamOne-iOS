//
//  UrlToUIImage.swift
//  Core
//
//  Created by 강현준 on 12/12/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Photos

public extension PHAsset {
  func getAssetThumbnail() -> UIImage {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    manager.requestImage(for: self,
                            targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                            contentMode: .aspectFit,
                            options: option,
                            resultHandler: {(result, info) -> Void in
      thumbnail = result!
    })
    return thumbnail
  }
}
