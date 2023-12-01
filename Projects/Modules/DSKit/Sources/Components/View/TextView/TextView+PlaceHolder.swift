//
//  TextView+PlaceHolder.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class TextView_PlaceHolder: UITextView {

    let disposeBag = DisposeBag()

    public var placeholder: String? {
        didSet {
            self.text = placeholder
        }
    }

    public var maxTextCount: Int = .max

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        bindTextView()
    }

    public func setFont(typo: SansNeo) {
        self.font = .setFont(font: typo)
    }

    private func bindTextView() {

        self.text = placeholder

        self.rx.didBeginEditing
            .withLatestFrom(self.rx.text.orEmpty)
            .map { $0 == self.placeholder }
            .subscribe(onNext: { [weak self] in
                if $0 == true {
                    self?.text = nil
                }
            })
            .disposed(by: disposeBag)

        self.rx.didEndEditing
            .withLatestFrom(self.rx.text.orEmpty)
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] in
                if $0 == true {
                    self?.text = self?.placeholder
                }
            })
            .disposed(by: disposeBag)

        self.rx.text.orEmpty
            .map {  [weak self] in
                return String($0.prefix(self?.maxTextCount ?? Int.max)) }
            .subscribe(onNext: { [weak self] text in
                self?.text = text
            })
            .disposed(by: disposeBag)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
