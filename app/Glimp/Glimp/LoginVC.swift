//
//  LoginVC.swift
//  SwiftLoginScreen
//
//  Created by Dipin Krishna on 31/07/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.

import UIKit
import MediaPlayer
import Alamofire

class LoginVC: UIViewController,UITextFieldDelegate {
    var moviePlayer: MPMoviePlayerController!
  
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtUsername.delegate = self;
        self.txtPassword.delegate = self;

        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("video", withExtension: "mov")!
        //var fileURL = NSURL.fileURLWithPath("http://localhost/test/xx.mp4")

        // Create and configure the movie player.
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
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

//    func textFieldDidBeginEditing(textField: UITextField!) -> Bool {
//        if (textField == self.txtUsername) {
//            self.txtUsername.text = "";
//        }
//        else if (textField == self.txtPassword){
//            
//            self.txtPassword.text = "";
//            
//        }
//        return false
//    }
//
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true);
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signinTapped(sender : UIButton) {
        var username:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        var userid:NSString
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            
            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string:"http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/jsonlogin2.php")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    
                    
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        NSLog("Login SUCCESS");
                        
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()

                        //let deviceToken = "a2222222a"
                        println(username)
                        
                        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let deviceToken = String(delegate.deviceToken)
                        println("here u go:")
                        println(deviceToken)

                        
                        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/devicetokenizer.php", parameters: ["username": username,"devicetoken": deviceToken,  "OS": "iOS"])

                            .response { (request, response, data, error) in
                                println(request)
                                println(response)
                                println(error)
                        }

                        println("---------")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
        
    }
 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

  
}
