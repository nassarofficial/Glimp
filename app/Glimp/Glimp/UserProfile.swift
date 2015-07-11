//
//  UserProfile.swift
//  Glimp
//
//  Created by Ahmed Nassar on 6/10/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class UserProfile: UIViewController {
    @IBOutlet weak var followers: UIButton!
    @IBOutlet weak var glimps: UIButton!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var following: UIButton!
    @IBOutlet weak var followbutton: UIButton!
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var user: UILabel!
    @IBAction func unwindToSegueprof (segue : UIStoryboardSegue) {}
    var datas: [JSON] = []
    var userid: String = ""
    var username: String = ""
    var f3: String = ""
    var friendid: String = ""
    @IBOutlet weak var tablespinner: UIActivityIndicatorView!
    
    @IBAction func followaction(sender: AnyObject) {
        if f3 == "not found"{
            println("NOT FRIEND")

            let parameters = [
                "user": friendid,
                "friend": userid
            ]
            
            self.followbutton.setImage(UIImage(named: "unfollowbutton.png"), forState: UIControlState.Normal)

//            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/addfriend.php", parameters: parameters)
//
//
            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/addfriend.php", parameters: parameters)
                .response { (request, response, data, error) in
                    self.updater()
            }

        }
        else{
            println("FRIEND")

            let parameters = [
                "uid": f3,
            ]
            self.followbutton.setImage(UIImage(named: "followbutton.png"), forState: UIControlState.Normal)

            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/removefriend.php", parameters: parameters)
                .response { (request, response, data, error) in
                    self.updater()
            }

//            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/removefriend.php", parameters: parameters)
//
//            self.updater()
            
        }

    }
    
    func updater(){
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")

        let baseURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/profileuser.php?username="+username+"&friend="+name!)
        
        let pointData = NSData(contentsOfURL: baseURL!, options: nil, error: nil)
        
        let points = NSJSONSerialization.JSONObjectWithData(pointData!,
            options: nil,
            error: nil) as! NSDictionary
        
        
        for point in points["profile"] as! NSArray {
            userid = String(stringInterpolationSegment: (point as! NSDictionary)["userider"]!)
            friendid = String(stringInterpolationSegment: (point as! NSDictionary)["useriderer"]!)
            user.text = String(stringInterpolationSegment: (point as! NSDictionary)["username"]!)
            
            let f1 = String(stringInterpolationSegment: (point as! NSDictionary)["friends"]!)
            let f2 = String(stringInterpolationSegment: (point as! NSDictionary)["followers"]!)
            f3 = String(stringInterpolationSegment: (point as! NSDictionary)["follow"]!)
            
//            println("fOLLOW: "+f3)
//            println("FOLLOWERS: "+f2)
//            println("FOLLOWERS: "+f1)

            
            
            if f3 == "not found"{
                followbutton.setImage(UIImage(named:"followbutton.png"),forState:UIControlState.Normal)
                let gl = String(stringInterpolationSegment: (point as! NSDictionary)["glimpcount"]!)
                
                self.following.setTitle(f1, forState: UIControlState.Normal)
                println(f1)
                println(f2)

                self.followers.setTitle(f2, forState: UIControlState.Normal)
                
                self.glimps.setTitle(gl, forState: UIControlState.Normal)
                
                
            
            }
            else{
                followbutton.setImage(UIImage(named:"unfollowbutton.png"),forState:UIControlState.Normal)
                let gl = String(stringInterpolationSegment: (point as! NSDictionary)["glimpcount"]!)
                
                self.following.setTitle(f1, forState: UIControlState.Normal)
                println(f1)
                println(f2)

                
                self.followers.setTitle(f2, forState: UIControlState.Normal)
                
                self.glimps.setTitle(gl, forState: UIControlState.Normal)
                
            }
            
            
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        automaticallyAdjustsScrollViewInsets = false
        self.tabBarController?.tabBar.hidden = false
        
        if username == name {
            followbutton.hidden = true
        }
        else {
            followbutton.hidden = false
        }
        
        scroller.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                dispatch_async(dispatch_get_main_queue()) { // 2

                let baseURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/profileuser.php?username="+self.username+"&friend="+name!)
                
                let pointData = NSData(contentsOfURL: baseURL!, options: nil, error: nil)
                
                let points = NSJSONSerialization.JSONObjectWithData(pointData!,
                    options: nil,
                    error: nil) as! NSDictionary
                
                
                for point in points["profile"] as! NSArray {
                    self.userid = String(stringInterpolationSegment: (point as! NSDictionary)["userider"]!)
                    self.friendid = String(stringInterpolationSegment: (point as! NSDictionary)["useriderer"]!)
                    self.user.text = String(stringInterpolationSegment: (point as! NSDictionary)["username"]!)
                    
                    let f1 = String(stringInterpolationSegment: (point as! NSDictionary)["friends"]!)
                    let f2 = String(stringInterpolationSegment: (point as! NSDictionary)["followers"]!)
                    self.f3 = String(stringInterpolationSegment: (point as! NSDictionary)["follow"]!)
                    
                    println("User Profile: "+self.userid)
                    println("Visited Profile: "+self.friendid)
                    println("Friend ID: "+self.f3)
                    
                    
                    
                    if self.f3 == "not found"{
                        
                        self.followbutton.setImage(UIImage(named:"followbutton.png"),forState:.Normal)
                        let gl = String(stringInterpolationSegment: (point as! NSDictionary)["glimpcount"]!)
                        
                        self.following.setTitle(f1, forState: UIControlState.Normal)
                        
                        
                        self.followers.setTitle(f2, forState: UIControlState.Normal)
                        
                        self.glimps.setTitle(gl, forState: UIControlState.Normal)
                        
                    }
                    else{
                        self.followbutton.setImage(UIImage(named:"unfollowbutton.png"),forState:UIControlState.Normal)
                        let gl = String(stringInterpolationSegment: (point as! NSDictionary)["glimpcount"]!)
                        
                        self.following.setTitle(f1, forState: UIControlState.Normal)
                        
                        
                        self.followers.setTitle(f2, forState: UIControlState.Normal)
                        
                        self.glimps.setTitle(gl, forState: UIControlState.Normal)
                        
                        
                    }
                    
                    
                    
                    
                    //self.location.text = (point as! NSDictionary)["location"] as? String
                    let urlString = (point as! NSDictionary)["profilepic"] as? String
                    let url = NSURL(string: urlString!)
                    var imageSize = 86 as CGFloat
                    self.imageView.frame.size.height = imageSize
                    self.imageView.frame.size.width  = imageSize
                    self.imageView.layer.cornerRadius = imageSize / 2.05
                    self.imageView.clipsToBounds = true

                    self.imageView.hnk_setImageFromURL(url!)
                    
                }
                
                Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/feeduser.php", parameters: ["userid": self.userid]).responseJSON { (request, response, json, error) in
                    if json != nil {
                        var jsonObj = JSON(json!)
                        if let data = jsonObj["glimps"].arrayValue as [JSON]?{
                            self.datas = data
                            self.tableView.reloadData()
                            self.tablespinner.hidden = true
                        }
                    }
                }
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.scroller.stopPullToRefresh()
                }
            }
            }, withAnimator: PacmanAnimator())

        
    }
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        // Test refreshing programatically
        scroller.startPullToRefresh()
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=false;
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell", forIndexPath: indexPath) as! UITableViewCell //1
        let data = datas[indexPath.row]
        let commentLabel = cell.viewWithTag(200) as? UILabel
        let timeLabel = cell.viewWithTag(250) as? UILabel
        
        
        if let captionLabel = cell.viewWithTag(100) as? UILabel {
            if let caption = data["loc"].string{
                captionLabel.text = caption
                let comment = data["description"].string
                commentLabel!.text = comment
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                var date = dateFormatter.dateFromString(data["time"].string!)
                
                
                //var date = NSDate(data["time"].string!)
                
                timeLabel!.text = timeAgoSinceDate(date!, numericDates: Bool(0))

            }
        }
        return cell
    }
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitSecond
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: nil)
        
        if (components.year >= 2) {
            return "\(components.year) years ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) months ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) days ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) hours ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) minutes ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) seconds ago"
        } else {
            return "Just now"
        }
        
    }

}
