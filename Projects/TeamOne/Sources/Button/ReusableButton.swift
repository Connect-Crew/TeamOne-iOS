//
//  ReusableButton.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import UIKit
import Core

open class ReusableButton: UIButton {
   // var padding : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    override public init(frame: CGRect) {
        super.init(frame: frame)
         print(#fileID, #function, #line,"_")
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    convenience public init(buttonTitle:String = "타이틀 없음",
                     bgColor:UIColor = .systemBlue,
                     tintColor:UIColor = .white,
                     textColor:UIColor = .black,
                     cornerRadius: CGFloat = 8,
                     width:CGFloat = 307,
                     height:CGFloat = 57,
                     image: UIImage? = nil
//                     icon:UIImage? = nil,
//                     iconWidth: CGFloat = 57, // 이미지 뷰의 너비
//                     iconHeight: CGFloat = 57 // 이미지 뷰의 높이
                     
     ){
        self.init(type: .custom)
        self.setTitle(buttonTitle, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = bgColor
        self.tintColor = tintColor
        self.layer.cornerRadius = cornerRadius
        //self.setImage(icon, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        if let image = image {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(imageView)

                // 이미지 뷰의 constraint를 버튼과 일치시킴
                imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            }
//        self.imageView?.widthAnchor.constraint(equalToConstant: width).isActive = true
//        self.imageView?.heightAnchor.constraint(equalToConstant: height).isActive = true
//        self.layer.borderWidth = 0.5 // Border 너비 설정
//        self.layer.borderColor = UIColor.black.cgColor

    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        print(#fileID,#function,#line,"_ ")

        //alignIconLeading()
       
    }
}
    //MARK: - 아이콘 정렬 관련
extension ReusableButton {
    
    /// 아이콘 왼쪽 정렬
    fileprivate func alignIconLeading() {
        contentHorizontalAlignment = .left
        let availableSpace = bounds.inset(by: contentEdgeInsets)

        let imgWidth = imageView?.frame.width ?? 0
        let imgHeight = bounds.height - (contentEdgeInsets.top + contentEdgeInsets.bottom) // 이미지 뷰의 높이를 버튼의 테두리 크기에 맞게 조정

        let availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        let leftPadding = (availableWidth / 2) - (imgWidth / 2)

       // imageView?.frame = CGRect(x: contentEdgeInsets.left, y: contentEdgeInsets.top, width: imgWidth, height: imgHeight)

        titleEdgeInsets = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0)
   }

    //MARK: - Button 클릭 애니메이션
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       //터치했을때 버튼 모양 바꾸기
            self.alpha = 0.7
        }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            //터치 종료후 버튼의 모양리셋
            self.alpha = 1.0

        }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            //터치가 취소될시 버튼 모양 리셋
            self.alpha = 1.0
        }
    
}


