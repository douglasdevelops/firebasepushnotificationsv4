//
//  AppDelegate.swift
//  pushmynotifs
//
//  Created by Jonny B on 9/19/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 8.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
            }
            
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            application.registerForRemoteNotifications()
            
        } else {
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
            
        }
        
        FirebaseApp.configure()
        
        //No Longer Needed With addition of didRefreshRegistrationToken delegate method
        //NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFCM()
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        let refreshedToken = InstanceID.instanceID().token()
        print("InstanceID token: \(String(describing: refreshedToken))")
        
        connectToFCM()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
    
    ///Delegate function to show banner notification if application is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
   

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func connectToFCM() {
       Messaging.messaging().shouldEstablishDirectChannel = true;
    }

}

