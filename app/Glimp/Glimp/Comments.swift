//
//  ViewController.swift
//  RevivalxTableView
//
//  Created by Mohammad Nurdin bin Norazan on 2/23/15.
//  Copyright (c) 2015 Nurdin Norazan Services. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class Comments: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var comments: UIScrollView!
    var glimpid:String!
    var user_id:String!
    var datas: [JSON] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postbut: UIButton!
    @IBOutlet weak var commentsfield: UITextField!

    @IBAction func posttoserver(sender: AnyObject) {
        if commentsfield.text.isEmpty {
            let alert = UIAlertView()
            alert.title = "Empty Comment"
            alert.message = "Please Enter Text In The Field"
            alert.addButtonWithTitle("Ok")
            alert.show()        }
        else{
        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/postcomments.php", parameters: [ "userid": user_id,
            "glimpid": glimpid,
            "comment": commentsfield.text])
            .response { (request, response, data, error) in
        }
        getdata()
        commentsfield.text=""
        self.tableView.reloadData()
        }
    }
    
    func getdata(){
        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/comments.php", parameters: ["comment": glimpid]).responseJSON { (request, response, json, error) in
            println(response)
            if json != nil {
                var jsonObj = JSON(json!)
                if let data = jsonObj["comments"].arrayValue as [JSON]?{
                    self.datas = data
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()) {

            self.getdata()
            
        }
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        
        comments.addGestureRecognizer(tapGesture)

    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
        super.viewWillDisappear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func registerForKeyboardNotifications() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func deregisterFromKeyboardNotifications() -> Void {
        println("Deregistering!")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size)!
        var buttonOrigin: CGPoint = self.postbut.frame.origin;
        var buttonHeight: CGFloat = self.postbut.frame.size.height;
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
            self.comments.setContentOffset(scrollPoint, animated: true)
            
        }
    }
    
    func hideKeyboard() {
        commentsfield.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        self.comments.setContentOffset(CGPointZero, animated: true)
    }


    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return datas.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell //1
        let data = datas[indexPath.row]
        let commentLabel = cell.viewWithTag(200) as? UILabel
        

        if let captionLabel = cell.viewWithTag(100) as? UILabel {
            if let caption = data["username"].string{
                captionLabel.text = caption
                let comment = data["comment"].string
                commentLabel!.text = comment

            }
        }
        if let imageView = cell.viewWithTag(101) as? UIImageView {
            if let urlString = data["profile_pic"].string{
                let url = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/profile_pics/"+urlString)
                let imageSize = 65 as CGFloat
                imageView.frame.size.height = imageSize
                imageView.frame.size.width  = imageSize
                imageView.layer.cornerRadius = imageSize / 2.0
                imageView.clipsToBounds = true

                imageView.hnk_setImageFromURL(url!)
            }
        }
        return cell
    }
    
}
