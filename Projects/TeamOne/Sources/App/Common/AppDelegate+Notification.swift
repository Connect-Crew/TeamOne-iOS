//
//  AppDelegate+UNUserNotification.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Core

extension AppDelegate: UNUserNotificationCenterDelegate {

    // apns 토큰 발급 완료 후 호출되는 메서드
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        Messaging.messaging().apnsToken = deviceToken
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                UserDefaultKeyList.Auth.APNsToken = nil
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaultKeyList.Auth.APNsToken = token
            }
        }
    }

    // foreground 상태일 때 push가 도착하는경우
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    // 1. 사용자가 노티를 종료했을 때 호출, 2. 사용자가 노티를 클릭해서 앱을 열었을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        print("Body: \(response.notification.request.content.body)")
        print("userInfo: \(response.notification.request.content.userInfo)")
    }
}

extension AppDelegate: MessagingDelegate {

    // FCM에 토큰이 되었을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}
