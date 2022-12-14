//
//  NotificationSettingsProvider.swift
//  WGTNotification
//
//  Created by Nguyen Quang on 08/08/2022.
//

import Foundation

public protocol NotificationSettingsProvider: class {
    /// Firebase refresh registration token:
    /// - Parameter fcmToken: get fcm token
    func refreshRegistrationToken(fcmToken: String)
    /// Firebase received registration token:
    /// - Parameter fcmToken: get fcm token
    func receivedRegistrationToken(fcmToken: String?)
}
