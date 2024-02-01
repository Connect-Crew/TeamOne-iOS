//
//  UITableView+RxDataSource.swift
//  Core
//
//  Created by 강현준 on 2/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UITableView {
    
    func itemSelected<Section, Item>(
        at dataSource: UITableViewDiffableDataSource<Section, Item>?
    ) -> Observable<Item> {
        return delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
            .map { object in
                return try castOrThrow(IndexPath.self, object[1])
            }
            .compactMap { indexPath in
                return dataSource?.itemIdentifier(for: indexPath)
            }
    }
    
    func itemDeselected<Section, Item>(
        at dataSource: UITableViewDiffableDataSource<Section, Item>?
    ) -> Observable<Item> {
        return delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didDeselectRowAt:)))
            .compactMap { object in
                return try castOrThrow(IndexPath.self, object[1])
            }
            .compactMap { indexPath in
                return dataSource?.itemIdentifier(for: indexPath)
            }
    }
    
    private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
    }
}
