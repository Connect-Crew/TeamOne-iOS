//
//  ViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/09.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core

class TESTViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let tmpView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tmpView.backgroundColor = .red

        view.addSubview(tmpView)
    }
}
