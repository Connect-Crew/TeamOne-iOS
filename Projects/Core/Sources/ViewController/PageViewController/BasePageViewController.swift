//
//  BasePageViewController.swift
//  Core
//
//  Created by 강현준 on 2023/11/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift

open class BasePageViewController: UIPageViewController {

    public var vcList:[UIViewController] = []
    public var currentIndex:Int = 0

    public var selectedPageSubject = BehaviorSubject<Int>(value: 0)

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
    }

    public func addVC(addList: [UIViewController]) {
        vcList = addList

        if vcList.count > 0 {
            self.setViewControllers([vcList[0]], direction: .forward, animated: true)
        }
    }

    public func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }

    open func goToPage(_ index: Int) {
        if currentIndex == index {
            return
        } else if index < vcList.count {
            var anim: UIPageViewController.NavigationDirection = .forward

            if index == 0 {
                anim = .reverse
            } else {
                if let firstViewControler = viewControllers?.first,
                   let currentIndex = vcList.firstIndex(of: firstViewControler) {
                    if index < currentIndex {
                        anim = .reverse
                    }
                }
            }

            self.setViewControllers([vcList[index]], direction: anim, animated: true)

            self.currentIndex = index
            self.selectedPageSubject.onNext(index)
        }
    }

}

extension BasePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index =  vcList.firstIndex(of: viewController) else {return nil}
        if index < 1 {
            return nil
        } else {
            return vcList[index - 1]
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index =   vcList.firstIndex(of: viewController) else {return nil}

        if index + 1 >= vcList.count {
            return nil
        } else {
            return vcList[index + 1]
        }
    }

    // page가 전환된 후 호출되는 메서드
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed {
            if let firstViewController = viewControllers?.first,
               let index = vcList.firstIndex(of: firstViewController) {
                self.currentIndex = index
                selectedPageSubject.onNext(currentIndex)
            }
        }
    }
}
