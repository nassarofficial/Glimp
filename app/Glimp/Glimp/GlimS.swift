//
//  GlimS.swift
//  Glimp
//
//  Created by Ahmed Nassar on 6/22/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit

class GlimS: UIViewController {
    
    var val: Int = 0
    @IBAction func backFromModal(segue: UIStoryboardSegue) {
        println("and we are back")
        // Switch to the second tab (tabs are numbered 0, 1, 2)
        self.tabBarController?.selectedIndex = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden=false;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=false;

        let prefs = NSUserDefaults.standardUserDefaults()
        let booler = prefs.integerForKey("glimper")
        println(booler)
        //prefs.setInteger(1, forKey: "glimper")
        //prefs.synchronize()

        performSegueWithIdentifier("glimpmodal", sender: self)
    
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
