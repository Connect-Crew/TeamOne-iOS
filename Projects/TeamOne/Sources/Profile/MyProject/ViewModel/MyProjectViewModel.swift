//
//  MyProjectViewModel.swift
//  TeamOne
//
//  Created by Junyoung on 2/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum MyProjectNavigation {
    case finish
    case back
}

final class MyProjectViewModel: ViewModel {
    
    private let getMyProjectsUseCase: GetMyProjectUseCase
    
    struct Input {
        let tapBack: Observable<Void>
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let projectList: Driver<[MyProjects]>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<MyProjectNavigation>()
    
    init(getMyProjectsUseCase: GetMyProjectUseCase) {
        self.getMyProjectsUseCase = getMyProjectsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        input.tapBack
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.navigation.onNext(.back)
            })
            .disposed(by: disposeBag)
        
        let result = input.viewWillAppear
            .withUnretained(self)
            .flatMap { this, _ -> Observable<Result<[MyProjects], Error>> in
                return this.getMyProjectsUseCase.excute()
                    .asObservable()
                    .asResult()
            }
        
        let projectList = result
            .compactMap { result -> [MyProjects]? in
                guard case .success(let data) = result else { return nil }
                return data
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(projectList: projectList)
    }
}
