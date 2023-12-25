//
//  SearchHistoryCell.swift
//  TeamOne
//
//  Created by Junyoung on 12/8/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import RxSwift

import Core
import DSKit
import Domain

class SearchHistoryCell: UICollectionViewCell {

    public var disposeBag = DisposeBag()
    
    private let historyImage = UIImageView().then {
        $0.image = .image(dsimage: .clock)
    }
    
    private let historyLabel = UILabel().then {
        $0.setLabel(text: "", typo: .button2, color: .teamOne.grayscaleFive)
        $0.numberOfLines = 0
    }
    
    public var historyTitle: String {
        historyLabel.text ?? ""
    }
    
    public let deleteHistoryButton = UIButton().then {
        $0.setImage(.image(dsimage: .closeButtonX), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func layout() {
        contentView.backgroundColor = .teamOne.background
        
        contentView.addSubview(historyImage)
        historyImage.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(deleteHistoryButton)
        deleteHistoryButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(historyLabel)
        historyLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(9)
            make.left.equalTo(historyImage.snp.right).offset(12)
            make.right.lessThanOrEqualTo(deleteHistoryButton.snp.left).offset(-12)
        }
    }

    func bind(title: String) {
        self.historyLabel.setLabel(text: title, typo: .button2, color: .teamOne.grayscaleFive)
    }
}
