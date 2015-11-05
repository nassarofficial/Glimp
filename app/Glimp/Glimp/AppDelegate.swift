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
    var loadedEnoughToDeepLink : Bool = false
    var deepLink : RemoteNotificationDeepLink?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let types: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        let settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        Instabug.startWithToken("8bf991235ff10a1897e63146cccca07b", captureSource:IBGCaptureSourceUIKit, invocationEvent:IBGInvocationEventShake)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        self.deviceToken = deviceTokenString
        
        print( deviceTokenString )
        
    }
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
        
        print( error.localizedDescription )
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        var tabBarController = self.window!.rootViewController as! UITabBarController
        
        if (userInfo["aps"] as? Dictionary<String, AnyObject> != nil)
        {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            let soundURL = NSBundle.mainBundle().URLForResource("splash", withExtension: "mp3")
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL!, &mySound)
            
            // Play
            AudioServicesPlaySystemSound(mySound);

        }
        print("hello")
        //scheduleNotification()
    }
    
    func scheduleNotification() {
        //UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        // Schedule the notification ********************************************
        if UIApplication.sharedApplication().scheduledLocalNotifications!.count == 0 {
            
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
        annotation: AnyObject) -> Bool {
            let urlString = url.scheme
            //print(url)
            if urlString.rangeOfString("fb") != nil {
                return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
                
            } else if url.host == "video" {
                
                let parameter = url.lastPathComponent
                
                
                let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
                let viewController: GlimpView = storyboard.instantiateViewControllerWithIdentifier("GlimpView") as! GlimpView
                viewController.glimpsid = parameter
                // Then push that view controller onto the navigation stack
                let rootViewController = self.window!.rootViewController as! UINavigationController
                rootViewController.pushViewController(viewController, animated: true)
                
            }
            
            return true

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
