//
//  ImageSlideView.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Then
import SnapKit
import SDWebImage

open class ImageSlideView: UIView {
    
    static var contentMode: UIImageView.ContentMode = .scaleAspectFill
    
    public let scrollView = UIScrollView()
    
    public let pageControl = UIPageControl().then {
        $0.isUserInteractionEnabled = false
        $0.currentPage = 0
        $0.hidesForSinglePage = true
        $0.currentPageIndicatorTintColor = .teamOne.mainColor
        $0.pageIndicatorTintColor = .teamOne.grayscaleTwo
    }
    
    public var images: [UIImage?] = [] {
        didSet {
            setupImagesInScrollView()
        }
    }
    
    public var path: [String] = [] {
        didSet {
            setupPathToInScrollView()
        }
    }
 
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
        setPageControl()
    }
    
    private func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(150)
        }
    }
    
    private func setPageControl() {
        addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    public func configure(with images: [UIImage?]) {
        self.images = images
    }

    private func setupImagesInScrollView() {

        scrollView.subviews.forEach { $0.removeFromSuperview() }

        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = ImageSlideView.contentMode
            imageView.frame = CGRect(
                x: CGFloat(index) * scrollView.frame.width,
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            scrollView.addSubview(imageView)
        }

        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
        pageControl.numberOfPages = images.count

    }
    
    private func setupPathToInScrollView() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        for (index, path) in path.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = ImageSlideView.contentMode
            imageView.frame = CGRect(
                x: CGFloat(index) * scrollView.frame.width,
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            
            scrollView.addSubview(imageView)
            
            imageView.setTeamOneImage(path: path)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(path.count), height: scrollView.frame.height)
        pageControl.numberOfPages = path.count
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        setupImagesInScrollView()
        setupPathToInScrollView()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageSlideView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(round(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
