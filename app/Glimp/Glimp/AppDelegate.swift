//
//  AppDelegate.swift
//  GLIMP
//
//  Created by nassar on 3/18/15.
//  Copyright (c) 2015 glimp. All rights reserved.
//
import UIKit
import CoreLocation
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var deviceToken: String=""
    var locationManager: CLLocationManager = CLLocationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var types: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        //Instabug.startWithToken("8bf991235ff10a1897e63146cccca07b", captureSource:IBGCaptureSourceUIKit, invocationEvent:IBGInvocationEventShake)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        
    }
    
}


extension AppDelegate : UIApplicationDelegate {
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        self.deviceToken = deviceTokenString
        
        println("sdfds")
        println( deviceTokenString )
        
    }
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
        
        println( error.localizedDescription )
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        var tabBarController = self.window!.rootViewController as! UITabBarController
        
        var temp : NSDictionary = userInfo
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            var alertMsg = info["alert"] as! String
//            var tabArray = tabBarController.tabBar.items as NSArray!
//            var tabItem = tabArray.objectAtIndex(3) as! UITabBarItem
//            tabItem.badgeValue = "34"

            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            let soundURL = NSBundle.mainBundle().URLForResource("splash", withExtension: "mp3")
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &mySound)
            
            // Play
            AudioServicesPlaySystemSound(mySound);

        }
        println("hello")
        //scheduleNotification()
    }
    
    func scheduleNotification() {
        //UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        // Schedule the notification ********************************************
        if UIApplication.sharedApplication().scheduledLocalNotifications.count == 0 {
            
            let notification = UILocalNotification()
            notification.alertBody = "Hey! Update your counter ;)"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = NSDate()
             
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }

    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {        let urlString = url.scheme
            if urlString!.rangeOfString("fb") != nil {
                return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
            } else {
                return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
            }
    }

    func applicationWillResignActive( application: UIApplication ) {
    }
    
    func applicationDidEnterBackground( application: UIApplication ) {
    }
    
    func applicationWillEnterForeground( application: UIApplication ) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate( application: UIApplication ) {
    }
    
    
}
