//
//  ReportReducer.swift
//  ReportFeature
//
//  Created by Junyoung on 2/25/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain

@Reducer
struct ReportReducer {
    
    var body: some Reducer<ReportState, ReportAction> {
        
        Reduce { state, action in
            switch action {
            case .reportButtonTapped(let type):
                
                return .none
            }
        }
    }
}
