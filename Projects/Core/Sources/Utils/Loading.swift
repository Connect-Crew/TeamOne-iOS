//
//  Loading.swift
//  Core
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class Loading {
    static var activitiIndicator = UIActivityIndicatorView()

    public static var shared = Loading()

    static var isFirst: Bool = false

    public static func start() {

        if isFirst == false {
            if let window: UIWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                window.addSubview(Loading.activitiIndicator)

                let screen = UIScreen.main.bounds

                activitiIndicator.style = .large
                activitiIndicator.frame = CGRect(x: screen.size.width / 2, y: screen.size.height / 2, width: 50, height: 50)

                isFirst = true

                activitiIndicator.isHidden = false
            }
        }

        activitiIndicator.isHidden = false
        activitiIndicator.startAnimating()
    }

    public static func stop() {
        activitiIndicator.stopAnimating()
        activitiIndicator.isHidden = true
    }
}
