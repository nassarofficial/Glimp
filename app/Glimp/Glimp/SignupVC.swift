//
//  SignupVC.swift
//  SwiftLoginScreen
//
//  Created by Dipin Krishna on 31/07/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//
import MediaPlayer
import UIKit
func isValidEmail(testStr : String) -> Bool {
    println("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    if emailTest.evaluateWithObject(testStr) {
        return true
    }
    return false
}

class SignupVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var txtConfirmPassword : UITextField!
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtPhonenumber : UITextField!
    var moviePlayer: MPMoviePlayerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtUsername.delegate = self;
        self.txtPassword.delegate = self;
        self.txtConfirmPassword.delegate = self;
        self.txtEmail.delegate = self;
        self.txtPhonenumber.delegate = self;

        // Do any additional setup after loading the view.
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
//        else if (textField == self.txtConfirmPassword){
//            
//            self.txtConfirmPassword.text = "";
//            
//        }
//        else if (textField == self.txtEmail){
//            
//            self.txtEmail.text = "";
//            
//        }
//        else if (textField == self.txtPhonenumber){
//            
//            self.txtPhonenumber.text = "";
//            
//        }
//        return false
//    }
//    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true);
//    }
    
    
 //   override func textFieldDidBeginEditing:(UITextField *); textField {
    
//    if (textField == self.numberToAdd) {
//    self.numberToAdd1.text = @"";
//    }
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
    
    @IBAction func gotoLogin(sender : UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func isNumeric(a: String) -> Bool {
        if let n = a.toInt() {
            return true
        } else {
            return false
        }
    }

    @IBAction func signupTapped(sender : UIButton) {
        var username:NSString = txtUsername.text as NSString
        var password:NSString = txtPassword.text as NSString
        var confirm_password:NSString = txtConfirmPassword.text as NSString
        var email:NSString = txtEmail.text as NSString
        var phonenumber:NSString = txtPhonenumber.text as NSString
        let count = password.length    // returns 5 (Int)

        if ( username.isEqualToString("") || password.isEqualToString("") || email.isEqualToString("") || phonenumber.isEqualToString("")) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if ( !password.isEqual(confirm_password)) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if ( count < 6){
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords less than 6 digits"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if ( isNumeric(phonenumber as String) == false ){
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Phone Number is not a digit"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if ( isValidEmail(email as String) == false ){
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Not a valid email"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }

        else {
            var OS : String = "iOS"
            var post:NSString = "username=\(username)&password=\(password)&c_password=\(confirm_password)&email=\(email)&phonenumber=\(phonenumber)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/jsonsignup.php")!
            
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
                        NSLog("Sign Up SUCCESS");
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
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
    

}
