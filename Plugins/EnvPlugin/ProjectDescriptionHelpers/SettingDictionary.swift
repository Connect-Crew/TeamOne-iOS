//
//  SettingDictionary.swift
//  EnvPlugin
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription

public extension SettingsDictionary {
    static let baseSettings: Self = [
        "OTHER_LDFLAGS" : [
            "$(inherited)",
            "-ObjC"
        ]
    ]
    
    func setCodeSignManual() -> SettingsDictionary {
        merging(["CODE_SIGN_STYLE": SettingValue(stringLiteral: "Manual")])
            .merging(["DEVELOPMENT_TEAM": SettingValue(stringLiteral: "Kang HyeonJun")])
            .merging(["CODE_SIGN_IDENTITY": SettingValue(stringLiteral: "$(CODE_SIGN_IDENTITY)")])
    }
    
    func setProvisioning() -> SettingsDictionary {
        merging(["PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "$(APP_PROVISIONING_PROFILE)")])
            .merging(["PROVISIONING_PROFILE": SettingValue(stringLiteral: "$(APP_PROVISIONING_PROFILE)")])
    }
}
