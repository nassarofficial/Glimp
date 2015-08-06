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

class CommentsNotif: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var comments: UIScrollView!
    var glimpid:String!
    var user_id:String!
    var datas: [JSON] = []
    @IBOutlet weak var postbut: UIButton!
    @IBOutlet weak var textView: UITextField!
    
    @IBOutlet weak var commentf: UIView!
    
    
    // Mentions
    var ticker : Int = 0
    var query : String = ""
    var ment : Int = 0
    var i = 0
    var tickerer = 0
    var flagger = ""
    var arr = [Int]()
    var mention = ""
    @IBOutlet var feed: UITableView!
    var datasMentions: [JSON] = []
    var payloader = ""

    @IBOutlet var suggester: UITableView!
    ///////
    
    @IBAction func posttoserver(sender: AnyObject) {
        println(user_id)
        println(glimpid)
        println(textView.text)
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let name = prefs.stringForKey("USERNAME")
        
        if textView.text.isEmpty {
            let alert = UIAlertView()
            alert.title = "Empty Comment"
            alert.message = "Please Enter Text In The Field"
            alert.addButtonWithTitle("Ok")
            alert.show()        }
        else{
            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/postcomments.php", parameters: [ "userid": name!,
                "glimpid": glimpid,
                "comment": textView.text])
                .response { (request, response, data, error) in
                    self.getdata()
                    self.feed.reloadData()
                    self.textView.text=""
                    
            }
        }
    }
    
    func getdata(){
        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/comments.php", parameters: ["comment": glimpid]).responseJSON { (request, response, json, error) in
            println(response)
            if json != nil {
                var jsonObj = JSON(json!)
                if let data = jsonObj["comments"].arrayValue as [JSON]?{
                    self.datas = data
                    self.feed.reloadData()
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        feed.addGestureRecognizer(tapGesture)
        textView.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)

        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        
        comments.addGestureRecognizer(tapGesture)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
        self.getdata()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println(segue.identifier)
        if (segue.identifier == "goto_glimp") {
            let secondViewController = segue.destinationViewController as! GlimpView
            secondViewController.glimpsid = self.glimpid
            
        }
        if (segue.identifier == "goto_userprofilemention") {
            let secondViewController = segue.destinationViewController as! UserProfile
            //  let ider = userid as String!
            
            let ider2 = payloader as String!
            //println(ider2)
            //  secondViewController.userid = ider
            
            secondViewController.username = ider2
        }
        if (segue.identifier == "goto_hash") {
            let secondViewController = segue.destinationViewController as! Hashtag
            //  let ider = userid as String!
            var stringer =  payloader
            let ider2 = stringer as String!
            //println(ider2)
            //  secondViewController.userid = ider
            
            secondViewController.loc = ider2
        }
        

        
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
        var buttonOrigin: CGPoint = self.commentf.frame.origin;
        var buttonHeight: CGFloat = self.commentf.frame.size.height;
        var visibleRect: CGRect = self.view.frame
        visibleRect.size.height -= keyboardSize.height
        
        if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
            var scrollPoint: CGPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight + 4)
            self.comments.setContentOffset(scrollPoint, animated: true)
            
        }
    }
    
    func hideKeyboard() {
        textView.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
        self.comments.setContentOffset(CGPointZero, animated: true)
    }
    
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == feed {
            return datas.count
        } else if tableView == suggester {
            return datasMentions.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell //1
        let data = datas[indexPath.row]
        let commentLabel = cell.viewWithTag(200) as? UITextView
        commentLabel?.resolveHashTags()

        
        if let captionLabel = cell.viewWithTag(100) as? UILabel {
            if let caption = data["username"].string{
                captionLabel.text = caption
                let comment = data["comment"].string
                commentLabel!.text = comment
                
            }
        }
        if let imageView = cell.viewWithTag(101) as? UIImageView {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell

            if tableView == feed {
                if let caption = data["name"].string {

            if let urlString = data["profile_pic"].string{
                let url = NSURL(string: urlString)
                println(url)
                let imageSize = 65 as CGFloat
                imageView.frame.size.height = imageSize
                imageView.frame.size.width  = imageSize
                imageView.layer.cornerRadius = imageSize / 2.0
                imageView.clipsToBounds = true
                
                imageView.hnk_setImageFromURL(url!)
            }
        }
    } else if tableView == suggester {
                let data = datasMentions[indexPath.row]
                if let caption = data["username"].string {
                    cell.labelCaption.text = caption
                }
    
            }
        }
        return cell
    }
    
    
    ///// Mentions
    
    func getdata(query:String){
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let name = prefs.stringForKey("USERNAME")
        var usernamep = String(name!)
        
        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/friendlist.php", parameters: ["username": usernamep, "query" : query]).responseJSON { (request, response, json, error) in
            println(response)
            if json != nil {
                var jsonObj = JSON(json!)
                if let data = jsonObj["predictions"].arrayValue as [JSON]?{
                    self.datasMentions = data
                    self.suggester.reloadData()
                }
            }
        }
        
    }
    
    func textField(Description: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(Description.text.utf16) + count(string.utf16) - range.length
        return newLength <= 150 // Bool
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if tableView == feed {
            println("nothing")
        } else if tableView == suggester {
            let currentCell = self.suggester.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
            let row = indexPath.row
            self.mention = datasMentions[row]["username"].string!
            suggester.hidden = true
            var gettext:String = textView!.text
            
            var before = gettext as String
            var ticker = arr[0]
            var tickerend = arr[1]
            var ender = count(before)-1
            var fhalf = before[0...ticker] + self.mention
            if (count(fhalf) < ender){
                suggester.hidden = true
                
            } else {
                suggester.hidden = true
                textView!.text = fhalf
            }
        }
    }
    func textFieldDidChange(textView: UITextField) { //Handle the text changes here
        var gettext:String = textView.text
        if count(gettext) != 0 {
            suggester.hidden = false
            ticker = count(gettext) - 1
            println(ticker)
            var idx = advance(gettext.startIndex,ticker)
            
            if (gettext[idx] == "@" && flagger == ""){
                arr.insert(ticker, atIndex: 0)
                arr.insert(ticker, atIndex: 1)
                flagger = "@"
                getdata(query)
                
                println("entered mention")
            }
            else if flagger == "@" {
                
                if (gettext[idx] != " "){
                    suggester.hidden = true
                    
                    arr.insert(ticker, atIndex: 1)
                    getdata(query)
                    
                    if (arr[0]+1 > arr[1]){
                        getdata(query)
                        suggester.hidden = false
                        query = ""
                    } else {
                        query = gettext[arr[0]+1...arr[1]]
                        getdata(query)
                        suggester.hidden = true
                    }
                    println(query)
                } else if (gettext[idx] == " "){
                    arr.insert(ticker, atIndex: 1)
                    
                    suggester.hidden = true
                    flagger = ""
                    getdata(query)
                    
                }
            }
            if (gettext[idx] == " "){
                //println(ticker)
                flagger = ""
                suggester.hidden = true
            }
            if (gettext[idx] == " " && flagger == "@"){
                arr.insert(ticker, atIndex: 1)
                suggester.hidden = true
                
            }
            if !(gettext.contains("@")){
                
                flagger = ""
                suggester.hidden = true
            }
            if (flagger == "" && gettext[idx] != "@"){
                suggester.hidden = true
            }
            if (flagger == "@" && gettext[idx] != "@"){
                suggester.hidden = false
                getdata(query)
                
            }
            
        } else {
            suggester.hidden = false
            
        }
    }
    

}
extension CommentsNotif : UITextViewDelegate {
    
    // increase the height of the textview as the user types
    func showHashTagAlert(tagType:String, payload:String){
        let alertView = UIAlertView()
        alertView.title = "\(tagType) tag detected"
        // get a handle on the payload
        alertView.message = "\(payload)"
        alertView.addButtonWithTitle("Ok")
        alertView.show()
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        // check for our fake URL scheme hash:helloWorld
        if let scheme = URL.scheme {
            switch scheme {
            case "hash" :
                payloader = URL.resourceSpecifier!
                println(payloader)
                performSegueWithIdentifier("goto_hash", sender: self)
                // showHashTagAlert("hash", payload: URL.resourceSpecifier!)
            case "mention" :
                payloader = URL.resourceSpecifier!
                performSegueWithIdentifier("goto_userprofilemention", sender: self)
            default:
                println("just a regular url")
            }
        }
        
        return true
    }
    
}


