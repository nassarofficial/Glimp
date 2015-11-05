//
//  ForgetMyPassword.swift
//  Glimp
//
//  Created by Ahmed Nassar on 6/28/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Alamofire
import MediaPlayer

class ForgetMyPassword: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var txtUsername: UITextField!
    var moviePlayer: MPMoviePlayerController!

    @IBOutlet weak var sendbutton: UIButton!
    @IBAction func getpassword(sender: AnyObject) {
        let email = txtUsername.text
        sendbutton.enabled = false
        Alamofire.request(.POST, "http://glimpglobe.com/v2/forgetpassword.php", parameters: ["email": email!, "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"])
            .responseJSON { response in
                if let JSON = response.result.value {
                    if JSON as! String == "{\"success\"}"{
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Password Changed"
                        alertView.message = "Your new password has been sent to your email!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        self.performSegueWithIdentifier("goto_login1", sender: self)
                    } else if JSON as! String == "{\"none\"}" {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Email Incorrect"
                        alertView.message = "Email Incorrect or doesnt exist!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        self.sendbutton.enabled = true
                        
                    }
                    else if self.txtUsername.text == "" {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Empty"
                        alertView.message = "Enter you email address."
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("video", withExtension: "mov")!
        self.txtUsername.delegate = self;

        self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
        
        self.moviePlayer.controlStyle = MPMovieControlStyle.None
        self.moviePlayer.scalingMode = MPMovieScalingMode.AspectFill
        
        self.moviePlayer.view.frame = self.view.frame
        self.view .insertSubview(self.moviePlayer.view, atIndex: 0)
        
        self.moviePlayer.play()
        
        // Loop video.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loopVideo", name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer)
    }
    
    func loopVideo() {
        self.moviePlayer.play()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        if (textField == self.txtUsername) {
            self.txtUsername.text = "";
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
