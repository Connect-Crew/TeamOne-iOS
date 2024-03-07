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

enum ReportErrorSate {
    case uncheckedError
    case otherTextEmptyError
    case normal
}

public class ReportReactor: Reactor {
    public let initialState = State()
    private let reportBuilder = ReportBuilder()
    
    public enum Action {
        case tapReport(ReportType)
        case otherText(String)
        case cancel
        case confirm
    }
    
    public enum Mutation {
        case reportToggle(ReportType)
        case setOtherText(String)
        case close
        case report
    }
    
    public struct State {
        var abusiveLanguage = false
        var lowParticipation = false
        var spamming = false
        var promotionalContent = false
        var inappropriateNicknameOrProfilePhoto = false
        var privacyInvasion = false
        var adultContent = false
        var other = false
        var otherTextState: OtherState?
        var reportState = ReportErrorSate.uncheckedError
        var isViewDismiss = false
        
        func isAllUnchecked() -> Bool {
            return !(abusiveLanguage || lowParticipation || spamming || promotionalContent || inappropriateNicknameOrProfilePhoto || privacyInvasion || adultContent || other)
        }
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapReport(let type):
            return Observable.just(.reportToggle(type))
        case .otherText(let text):
            return Observable.just(.setOtherText(text))
        case .cancel:
            return Observable.just(.close)
        case .confirm:
            return Observable.just(.report)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .reportToggle(let type):
            switch type {
            case .abusiveLanguage:
                newState.abusiveLanguage.toggle()
                reportBuilder.setAbusiveLanguage(newState.abusiveLanguage)
            case .lowParticipation:
                newState.lowParticipation.toggle()
                reportBuilder.setlowParticipation(newState.lowParticipation)
            case .spamming:
                newState.spamming.toggle()
                reportBuilder.setSpamming(newState.spamming)
            case .promotionalContent:
                newState.promotionalContent.toggle()
                reportBuilder.setPromotionalContent(newState.promotionalContent)
            case .inappropriateNicknameOrProfilePhoto:
                newState.inappropriateNicknameOrProfilePhoto.toggle()
                reportBuilder.setInappropriateNicknameOrProfilePhoto(newState.inappropriateNicknameOrProfilePhoto)
            case .privacyInvasion:
                newState.privacyInvasion.toggle()
                reportBuilder.setPrivacyInvasion(newState.privacyInvasion)
            case .adultContent:
                newState.adultContent.toggle()
                reportBuilder.setAdultContent(newState.adultContent)
            case .other:
                newState.other.toggle()
                reportBuilder.setOther(newState.other)
                if newState.other {
                    newState.otherTextState = .enable(true)
                } else {
                    newState.otherTextState = .enable(false)
                }
            }
            
            if newState.isAllUnchecked() {
                newState.reportState = .uncheckedError
            } else {
                newState.reportState = .normal
            }
            
        case .setOtherText(let text):
            if text.isEmpty && newState.other {
                newState.reportState = .otherTextEmptyError
                newState.otherTextState = .error
            } else if !text.isEmpty {
                newState.reportState = .normal
                newState.otherTextState = .edit
            }
            reportBuilder.setOtherText(text)
            
        case .close:
            newState.isViewDismiss = true
        case .report:
            reportBuilder.build()
            newState.isViewDismiss = true
        }
        
        return newState
    }
}
