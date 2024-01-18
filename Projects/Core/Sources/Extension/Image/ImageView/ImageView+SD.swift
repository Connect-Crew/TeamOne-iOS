//
//  ImageView+SD.swift
//  Core
//
//  Created by 강현준 on 1/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import SDWebImage

public extension UIImageView {
    
    static var baseNetworkURL: String {
        return "http://teamone.kro.kr:9080"
    }
    
    /// path: api통신 후 가져온 이미지 주소
    func setTeamOneImage(path: String?) {
        
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_imageIndicator?.startAnimatingIndicator()
        
        if path != "",
           let urlString = path,
           let url = URL(string: Self.baseNetworkURL + urlString) {
            self.sd_setImage(with: url, completed: { _,_,_,_  in
                
                self.sd_imageIndicator?.stopAnimatingIndicator()
                
            })
        } else {
            self.sd_imageIndicator?.stopAnimatingIndicator()
        }
    }
    
    static func pathToImage(path: [String?], completion: @escaping ([UIImage?]) -> Void) {
        
        Loading.start(stopTouch: false)
        
        var images: [UIImage?] = Array(repeating: nil, count: path.count)
            let group = DispatchGroup()
            
            for (index, pathString) in path.enumerated() {
                guard let pathToString = pathString,
                    let url = URL(string: baseNetworkURL + pathToString) else {
                    continue
                }
                
                group.enter() // 다운로드 시작
                
                SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, _, error, _, _, _) in
                    if let downloadedImage = image {
                        images[index] = downloadedImage // 이미지 다운로드 성공
                    } else {
                        print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                    }
                    group.leave() // 다운로드 완료(성공/실패)를 그룹에 알립니다.
                }
            }
            
            group.notify(queue: .main) {
                completion(images) // 모든 이미지 다운로드가 완료되면 콜백을 호출합니다.
                Loading.stop()
            }
    }
}
