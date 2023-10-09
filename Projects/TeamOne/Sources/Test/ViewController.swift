//
//  ViewController.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/09.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 50, width: 300, height: 300)
        label.text = "TEST"
        label.textColor = .black
        
        view.backgroundColor = .white
        
        view.addSubview(label)
    }
}
