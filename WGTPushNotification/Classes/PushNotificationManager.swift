//
//  PushNotificationManager.swift
//  WGTNotification
//
//  Created by Nguyen Quang on 08/08/2022.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

public class PushNotificationManager: NSObject {
    public static let sharedInstance = PushNotificationManager()
    
    public func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (permissionGranted, error) in
            DispatchQueue.main.async {
                print("registerForPushNotifications permissionGranted? \(permissionGranted)")
                guard permissionGranted else { return }
                self.getNotificationSettings()
            }
        }
    }
    
    private func getNotificationSettings() {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.delegate = self
        Messaging.messaging().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,
                                                                completionHandler: {_, _ in })
        UIApplication.shared.registerForRemoteNotifications()
    }
}

// MARK: - UNUserNotificationCenterDelegate, UIApplicationDelegate
extension PushNotificationManager: UNUserNotificationCenterDelegate, UIApplicationDelegate {
    
    /// Tells the delegate when Apple Push Notification service cannot successfully complete the registration process.
    /// - Parameters:
    ///   - application: The app object that initiated the remote-notification registration process.
    ///   - error: An NSError object that encapsulates information why registration did not succeed. The app can choose to display this information to the user.
    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("register notification fail: \(error)")
    }
    
    /// Called when your app has received a remote notification.
    /// - Parameters:
    ///   - application: The app object that received the remote notification.
    ///   - userInfo: A dictionary that contains information related to the remote notification
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }
    
    ///  Tells the delegate that the app successfully registered with Apple Push Notification service (APNs).
    /// - Parameters:
    ///   - application: The app object that initiated the remote-notification registration process.
    ///   - deviceToken:  A globally unique token that identifies this device to APNs. Send this token to the server that you use to generate remote notifications.
    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("deviceToken: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// Tells the app that a remote notification arrived that indicates there is data to be fetched.
    /// - Parameters:
    ///   - application: Your singleton app object.
    ///   - userInfo: A dictionary that contains information related to the remote notification
    ///   - completionHandler: The block to execute when the download operation is complete.
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    /// Asks the delegate to process the user's response to a delivered notification.
    /// - Parameters:
    ///   - center: The shared user notification center object that received the notification.
    ///   - response: The user’s response to the notification. This object contains the original notification and the identifier string for the selected action.
    ///   - completionHandler: The block to execute when you have finished processing the user’s response. You must execute this block at some point after processing the user's response to let the system know that you are done. The block has no return value or parameters.
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
    
    /// Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
    /// - Parameters:
    ///   - center: The shared user notification center object that received the notification.
    ///   - notification: The notification that is about to be delivered. Use the information in this object to determine an appropriate course of action
    ///   - completionHandler: The block to execute with the presentation option for the notification. Always execute this block at some point during your implementation of this method.
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

// MARK: - MessagingDelegate
extension PushNotificationManager: MessagingDelegate {
    /// Firebase refresh registration token:
    /// - Parameter fcmToken: Get Fcm token
    public func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase refresh registration token: \(fcmToken)")
        
    }
    /// Firebase refresh registration token:
    /// - Parameter fcmToken: Get Fcm token
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase received registration token: \(fcmToken ?? "")")
    }
}

