//
//  LoginCoordinator.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject

enum LoginCoordinatorResult {
    case finish
}

final class LoginCoordinator: BaseCoordinator<LoginCoordinatorResult> {
    
    let finish = PublishSubject<LoginCoordinatorResult>()
    
   
    //private let navigationControllers = UINavigationController()
    
    override func start() -> Observable<LoginCoordinatorResult> {
        //  push(navigationController, animated: true)
        showLogin()
        return finish
    }
    
    func showLogin() {
        let viewModel = DIContainer.shared.resolve(LoginViewModel.self)
        // let viewModel = DIContainer.shared.resolve(SignUpCompleteViewModel.self)
        
        viewModel.navigation
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
        let viewController = Inject.ViewControllerHost(LoginViewController(viewModel: viewModel))
        // let viewController = Inject.ViewControllerHost(SignUpCompleteViewController(viewModel: viewModel))
        
        
        push(viewController, animated: true, isRoot: true)
    }
    
    func startButtonHandling(in viewController: UIViewController) {
          if let myViewController = viewController as? LoginViewController {
              myViewController.buttonTapObservable
                  .subscribe(onNext: { [weak self] in
                      // 버튼이 눌렸을 때의 작업을 수행
                      print("Button tapped")
                      // 다른 작업 수행 가능
                  })
                  .disposed(by: disposeBag)
          }
      }
   

  
    
}
