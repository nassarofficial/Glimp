//
//  Report.swift
//  Glimp
//
//  Created by Ahmed Nassar on 8/4/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit

class Report: UIViewController {
    var glimpid:String = ""
    
    @IBAction func unwindToSegueprofile (segue : UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden=false;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "report_spam") {
            let secondViewController = segue.destinationViewController as! Reporter
            
            let ider = glimpid as String!
            //  println(ider2)
            
            secondViewController.glimpid = ider
            secondViewController.reporttype = "1"
            
        }
        if (segue.identifier == "report_inap") {
            let secondViewController = segue.destinationViewController as! Reporter
            
            let ider = glimpid as String!
            //  println(ider2)
            
            secondViewController.glimpid = ider
            secondViewController.reporttype = "2"
            
        }
        if (segue.identifier == "report_fake") {
            let secondViewController = segue.destinationViewController as! Reporter
            
            let ider = glimpid as String!
            //  println(ider2)
            
            secondViewController.glimpid = ider
            secondViewController.reporttype = "3"
            
        }
        if (segue.identifier == "report_uploader") {
            let secondViewController = segue.destinationViewController as! Reporter
            
            let ider = glimpid as String!
            //  println(ider2)
            
            secondViewController.glimpid = ider
            secondViewController.reporttype = "4"
            
        }

        
    }

}
