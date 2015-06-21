//
//  Profile.swift
//  GLIMP
//
//super.viewDidAppear(animated)
//let prefs = NSUserDefaults.standardUserDefaults()
//let name = prefs.stringForKey("USERNAME")
//self.user.text = name


//  Created by nassar on 3/21/15.
//  Copyright (c) 2015 glimp. All rights reserved.
//

import UIKit
import Alamofire
import Haneke


class Profile: UIViewController {
    
    @IBOutlet weak var followers: UIButton!
    @IBOutlet weak var glimps: UIButton!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var following: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var user: UILabel!
    @IBAction func unwindToSegueprof (segue : UIStoryboardSegue) {}
    var datas: [JSON] = []
    var userid: String = ""
    
    
    func getprofile(){
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")

        dispatch_async(dispatch_get_main_queue()) {
            
            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/feed.php", parameters: ["userid": self.userid]).responseJSON { (request, response, json, error) in
                if json != nil {
                    var jsonObj = JSON(json!)
                    if let data = jsonObj["glimps"].arrayValue as [JSON]?{
                        self.datas = data
                        self.tableView.reloadData()
                    }
                }
            }
            
        
        self.tabBarController?.tabBar.hidden = false
        let baseURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/profile.php?username="+name!)
        //println(baseURL)
        
        let pointData = NSData(contentsOfURL: baseURL!, options: nil, error: nil)
        
        let points = NSJSONSerialization.JSONObjectWithData(pointData!,
            options: nil,
            error: nil) as! NSDictionary
        
        
        for point in points["profile"] as! NSArray {
            self.userid = String(stringInterpolationSegment: (point as! NSDictionary)["id"]!)
            let f1 = String(stringInterpolationSegment: (point as! NSDictionary)["friends"]!)
            let f2 = String(stringInterpolationSegment: (point as! NSDictionary)["followers"]!)
            let gl = String(stringInterpolationSegment: (point as! NSDictionary)["glimpcount"]!)
            
            self.following.setTitle(f1, forState: UIControlState.Normal)
            
            
            self.followers.setTitle(f2, forState: UIControlState.Normal)
            
            self.glimps.setTitle(gl, forState: UIControlState.Normal)
            
            
            
            self.location.text = (point as! NSDictionary)["location"] as? String
            let urlString = (point as! NSDictionary)["profilepic"] as? String
            let url = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/"+urlString!)
            self.imageView.hnk_setImageFromURL(url!)
            
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        self.user.text = name
        UIApplication.sharedApplication().statusBarHidden=false;


        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

    }
    
    override func viewWillAppear(animated: Bool) {
        getprofile()
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
                
                //timeLabel!.text = data["time"].string!
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
