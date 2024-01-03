//
//  ViewController.swift
//  CoreTests
//
//  Created by 강현준 on 2023/10/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift

open class ViewController: UIViewController {

    public var disposeBag = DisposeBag()

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        layout()
        bind()
    }

    open func layout() {}
    open func bind() {}

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    deinit {
        print("Deinit \(type(of: self))")
    }
}
