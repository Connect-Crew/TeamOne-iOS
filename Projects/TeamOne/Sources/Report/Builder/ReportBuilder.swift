//
//  ReportBuilder.swift
//  TeamOne
//
//  Created by Junyoung on 3/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Core

class ReportBuilder {
    private var abusiveLanguage: Bool = false
    private var lowParticipation: Bool = false
    private var spamming: Bool = false
    private var promotionalContent: Bool = false
    private var inappropriateNicknameOrProfilePhoto: Bool = false
    private var privacyInvasion: Bool = false
    private var adultContent: Bool = false
    private var other: Bool = false
    private var otherText: String?
    
    func setAbusiveLanguage(_ state: Bool) {
        abusiveLanguage = state
    }
    
    func setlowParticipation(_ state: Bool) {
        lowParticipation = state
    }
    
    func setSpamming(_ state: Bool) {
        spamming = state
    }
    
    func setPromotionalContent(_ state: Bool) {
        promotionalContent = state
    }
    
    func setInappropriateNicknameOrProfilePhoto(_ state: Bool) {
        inappropriateNicknameOrProfilePhoto = state
    }
    
    func setPrivacyInvasion(_ state: Bool) {
        privacyInvasion = state
    }
    
    func setAdultContent(_ state: Bool) {
        adultContent = state
    }
    
    func setOther(_ state: Bool) {
        other = state
    }
    
    func setOtherText(_ text: String) {
        otherText = text
    }
    
    func build() {
        print("욕설 : \(abusiveLanguage)")
        print("참여율 : \(lowParticipation)")
        print("스팸 : \(spamming)")
        print("홍보 : \(promotionalContent)")
        print("부적절 : \(inappropriateNicknameOrProfilePhoto)")
        print("개인 : \(privacyInvasion)")
        print("19 : \(adultContent)")
        print("other : \(other), otherText : \(otherText)")
        print("Build!")
    }
}
