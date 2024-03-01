//
//  ReportReactor.swift
//  TeamOne
//
//  Created by Junyoung on 3/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import ReactorKit
import UIKit
import Core

public class ReportReactor: Reactor {
    public let initialState = State()
    
    public enum Action {
        case tapReport(ReportType)
    }
    
    public enum Mutation {
        case reportToggle(ReportType)
    }
    
    public struct State {
        var abusiveLanguage = false
        var lowParticipation = false
        var spamming = false
        var promotionalContent = false
        var inappropriateNicknameOrProfilePhoto = false
        var privacyInvasion = false
        var adultContent = false
        var other = ""
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapReport(let type):
            return Observable.just(.reportToggle(type))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .reportToggle(let type):
            switch type {
            case .abusiveLanguage:
                newState.abusiveLanguage.toggle()
            case .lowParticipation:
                newState.lowParticipation.toggle()
            case .spamming:
                newState.spamming.toggle()
            case .promotionalContent:
                newState.promotionalContent.toggle()
            case .inappropriateNicknameOrProfilePhoto:
                newState.inappropriateNicknameOrProfilePhoto.toggle()
            case .privacyInvasion:
                newState.privacyInvasion.toggle()
            case .adultContent:
                newState.adultContent.toggle()
            case .other(let text):
                newState.other = text
            }
        }
        
        return newState
    }
}
