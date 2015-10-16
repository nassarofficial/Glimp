//
//  ChangePassword.swift
//  Glimp
//
//  Created by Ahmed Nassar on 6/29/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Alamofire

class ChangePassword: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var confirmpass: UITextField!
    @IBOutlet weak var newpass: UITextField!
    @IBOutlet weak var current: UITextField!
    
    @IBOutlet weak var sendbutton: UIButton!
    @IBAction func changepassword(sender: AnyObject) {
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")

        let password = newpass.text! as NSString
        let count = password.length
        if (self.confirmpass.text == "" || self.newpass.text == "" || self.confirmpass.text == "" ) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Empty Field"
            alertView.message = "An empty field detected, check your fields."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if (!newpass.text!.isEqual(confirmpass.text)){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Passwords arent matching"
            alertView.message = "Your passwords arent matching."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if (count < 6) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Password Length"
            alertView.message = "Your password should be more than 6 characters"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else {
            
            Alamofire.request(.POST, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/changepassword.php", parameters: ["userid":name!,"currentpassword": self.current.text!,"newpassword": self.newpass.text!])
                .responseString { response in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")

                    if JSON == "{\"success\"}"{
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Password Changed"
                        alertView.message = "Your new password has been sent to your email!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        self.performSegueWithIdentifier("goto_login1", sender: self)
                    }
                    else if JSON == "{\"error\"}"{
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Current Password"
                        alertView.message = "This isn't your current password, try again!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        self.sendbutton.enabled = true
                    }
                        
                    else {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Error"
                        alertView.message = "Error, Please try again later!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        self.sendbutton.enabled = true
                    }
                    }

            }
                        
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmpass.delegate = self
        self.newpass.delegate = self
        self.current.delegate = self

        // Do any additional setup after loading the view.
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
