//  BaseTabBarVC.swift
//  RootFeature
//
//  Created by Junyoung Lee on 2023/09/05.
//  Copyright © 2023 Quriously. All rights reserved.
//

import UIKit
import RxSwift

import Core
import BaseFeatureDependency
import DSKit

class BaseTabBarVC: UITabBarController, ViewModelBindable {
    
    let tabBarView = TabBarView()
    
    lazy var tabLabels = [UILabel]()
    lazy var tabIcons = [UIImageView]()
    
    var viewModel: BaseTabBarViewModel?
    
    let tabBarDidMove = PublishSubject<Void>()
    let startCoordinator = PublishSubject<(page: TabBarPage, tabNavigationController: UINavigationController)>()
    
    private var isAlreadyLoaded = false
    
    var disposeBag = DisposeBag()
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if Utils.deviceType() == .iphone {
            return .portrait
        } else {
            return .allButUpsideDown
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isAlreadyLoaded {
            setup()
            isAlreadyLoaded = true
        }
    }
    
    func setup() {
        self.tabBar.isHidden = true
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        
        let tabBarContainer = UIView().then {
            $0.backgroundColor = .lightBackgroundPaper
        }
        
        self.view.addSubview(tabBarContainer)
        tabBarContainer.snp.makeConstraints { make in
            make.height.equalTo(75 + Utils.safeAreaBottomInset())
            make.left.right.bottom.equalToSuperview()
        }
        
        tabBarContainer.addSubview(tabBarView)
        self.tabBarView.snp.makeConstraints { make in
            make.height.equalTo(75)
            make.left.right.top.equalToSuperview()
        }
        
        let pages: [TabBarPage] = TabBarPage.allCases
        
        let viewControllers: [UINavigationController] = pages.map {
            self.createTabNavigationController(page: $0)
        }
        
        self.configureTabBarController(with: viewControllers)
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = BaseTabBarViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            tabBarDidMove: tabBarDidMove.asObservable(),
            startCoordinator: startCoordinator
        )
        
        let output = viewModel.transform(input: input)
        
        output.tokenExpiredAlert
            .drive(rx.presentAlert)
            .disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
        Log.debug("deinit: \(type(of: self))")
    }
}

extension BaseTabBarVC {
    private func createTabNavigationController(page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        tabNavigationController.setNavigationBarHidden(true, animated: false)
        self.configureTabBarItem(of: page)
        self.startCoordinator.onNext((page: page, tabNavigationController: tabNavigationController))
        return tabNavigationController
    }
    
    /// 탭바 아이템 생성
    private func configureTabBarItem(of page: TabBarPage) {
        let viewContainer = UIView()
        
        let title = UILabel().then {
            $0.setLabel(text: page.tabTitle(), font: .bottomNavigationLabel)
            $0.textColor = .lightSecondaryMain
            $0.tag = page.pageOrderNumber()
        }
        
        let icon = UIImageView().then {
            $0.image = UIImage(named: page.tabIconName())
            $0.tintColor = .lightSecondaryMain
            $0.alpha = 0.54
        }
        
        let button = MaterialButton(.none).then {
            $0.tag = page.pageOrderNumber()
        }
        
        tabLabels.append(title)
        tabIcons.append(icon)
        
        button.addTarget(self, action: #selector(moveTab), for: .touchUpInside)
        
        viewContainer.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.height.width.equalTo(26)
        }
        
        viewContainer.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(0)
            make.bottom.equalToSuperview().inset(15)
        }
        
        viewContainer.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(0)
        }
        
        button.setID(page.qaID)
        
        tabBarView.customTabBar.addArrangedSubview(viewContainer)
        
    }
    
    /// Default Page 설정
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.setViewControllers(tabViewControllers, animated: true)
        
        let firstPage = TabBarPage.klassList.pageOrderNumber()
        
        self.setSelectedIndex(firstPage)
        
    }
    
    func selectPage(_ page: TabBarPage) {
        self.selectedIndex = page.pageOrderNumber()
        self.tabImageChange(page.pageOrderNumber())
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        self.selectedIndex = page.pageOrderNumber()
        self.tabBarDidMove.onNext(())
        self.tabImageChange(index)
    }
    
    func currentPage() -> TabBarPage? {
        return TabBarPage(index: self.selectedIndex)
    }
    
    @objc func moveTab(_ sender: UIButton) {
        self.setSelectedIndex(sender.tag)
    }
    
    func tabImageChange(_ tabIndex: Int) {
        for index in 0 ..< TabBarPage.allCases.count {
            if index == tabIndex {
                self.tabIcons[index].alpha = 1.0
                self.tabIcons[index].tintColor = .lightPrimaryMain
                self.tabLabels[index].textColor = .lightPrimaryMain
            } else {
                self.tabIcons[index].alpha = 0.4
                self.tabIcons[index].tintColor = .lightTextSecondary
                self.tabLabels[index].textColor = .lightTextSecondary
            }
        }
    }
}
