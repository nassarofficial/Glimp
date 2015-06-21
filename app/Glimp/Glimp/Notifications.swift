//
//  Profile.swift
//  GLIMP
//
//  Created by nassar on 3/21/15.
//  Copyright (c) 2015 glimp. All rights reserved.
//

import UIKit


class Notifications: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=false;

    }
}
