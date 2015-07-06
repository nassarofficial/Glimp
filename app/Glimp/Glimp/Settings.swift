//
//  ViewController.swift
//  Glimp
//
//  Created by Ahmed Nassar on 6/10/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit

class Settings: UIViewController {
    @IBAction func unwindToSegueS (segue : UIStoryboardSegue) {}


    @IBAction func privacypolicy(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.glimpnow.com/#!CopyofPrivacy/c1rrp")!)

    }
    
    @IBAction func termsofuse(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.glimpnow.com/#!CopyofTerms/c1x6q")!)

    }
    @IBAction func logout(sender: AnyObject) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)

    }
    
    @IBAction func changepassword(sender: AnyObject) {
        self.performSegueWithIdentifier("change_password", sender: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
