//
//  AppDelegate.swift
//  GLIMP
//
//  Created by nassar on 3/18/15.
//  Copyright (c) 2015 glimp. All rights reserved.
//
import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var deviceToken: String=""
    var locationManager: CLLocationManager = CLLocationManager()
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();

        
        return true
        
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
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError! ) {
        
        println( error.localizedDescription )
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        println("Recived: \(userInfo)")
        //Parsing userinfo:
        var temp : NSDictionary = userInfo
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            var alertMsg = info["alert"] as! String
            var alert: UIAlertView!
            alert = UIAlertView(title: "", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }

    }

    func applicationWillResignActive( application: UIApplication ) {
    }
    
    func applicationDidEnterBackground( application: UIApplication ) {
    }
    
    func applicationWillEnterForeground( application: UIApplication ) {
    }
    
    func applicationDidBecomeActive( application: UIApplication ) {
    }
    
    func applicationWillTerminate( application: UIApplication ) {
    }
    
    
}
