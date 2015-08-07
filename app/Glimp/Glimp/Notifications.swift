//
//  Notifications.swift
//  Glimp
//
//  Created by Ahmed Nassar on 6/27/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class Notifications: UIViewController {
    var datas: [JSON] = []
    var user_id : String = ""
    var glimpid : String = ""
    var username : String = ""
    var broadcast_id : String = ""
    
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        let prefs = NSUserDefaults.standardUserDefaults()
        
        let name = prefs.stringForKey("USERNAME")
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                dispatch_sync(dispatch_get_global_queue(
                    Int(QOS_CLASS_USER_INTERACTIVE.value), 0)) {
                        
        
                Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/notifications.php", parameters: ["userid": name!]).responseJSON { (request, response, json, error) in
                    println(response)
                    if json != nil {
                        var jsonObj = JSON(json!)
                        if let data = jsonObj["notifications"].arrayValue as [JSON]?{
                            self.datas = data
                            self.tableView.reloadData()
                        }
                    }
                }
                }

                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.stopPullToRefresh()
                }
            }
            }, withAnimator: PacmanAnimator())

    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        (tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue = nil
        tableView.startPullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println(segue.identifier)
        if (segue.identifier == "goto_comments") {
            let secondViewController = segue.destinationViewController as! CommentsNotif
            println("before glimp:" + self.glimpid)
            secondViewController.glimpid = self.glimpid
            
        }
        else if (segue.identifier == "goto_profile") {
            let secondViewController = segue.destinationViewController as! UserProfile
            let ider = user_id as String!
            println("before glimp:" + user_id)
            let ider2 = username as String!

            //println(ider2)
            secondViewController.userid = ider
            secondViewController.username = ider2

        }
        else if (segue.identifier == "goto_broadreq") {
            let secondViewController = segue.destinationViewController as! BroadcastReq
            secondViewController.broadcast_id = self.broadcast_id
            println(self.broadcast_id)
        }

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
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell //1
        let data = datas[indexPath.row]
        let notification = cell.viewWithTag(150) as? UILabel
        let timeLabel = cell.viewWithTag(200) as? UILabel

        
        if let captionLabel = cell.viewWithTag(100) as? UILabel {
            if let caption = data["username"].string{
                captionLabel.text = caption
                var type = data["type"]
                if type == 1 {
                    notification!.text = "is now following you."
                }
                else if type == 2 {
                    notification!.text = "commented on your glimp."
                }
                else if type == 3 {
                    notification!.text = "wants to know what's going around near you!"
                }
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                var date = dateFormatter.dateFromString(data["timestamp"].string!)
                println(date)
                                
                timeLabel!.text = timeAgoSinceDate(date!, numericDates: Bool(0))

            }
        }
        if let imageView = cell.viewWithTag(250) as? UIImageView {
            if let urlString = data["profile_pic"].string{
                let url = NSURL(string: urlString)
                println(url)
                let imageSize = 65 as CGFloat
                imageView.frame.size.height = imageSize
                imageView.frame.size.width  = imageSize
                imageView.layer.cornerRadius = imageSize / 2.75
                imageView.clipsToBounds = true
                
                imageView.hnk_setImageFromURL(url!)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let currentCell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
        let row = indexPath.row
        println(datas[row])
        self.glimpid = String(stringInterpolationSegment: datas[row]["g_id"])
        self.user_id = String(stringInterpolationSegment: datas[row]["f_id"])
        self.broadcast_id = String(stringInterpolationSegment: datas[row]["b_id"])

        self.username = String(stringInterpolationSegment: datas[row]["username"])
        
        if datas[row]["type"] == 1 {
            performSegueWithIdentifier("goto_profile", sender: self)
        } else if datas[row]["type"] == 2 {
            performSegueWithIdentifier("goto_comments", sender: self)
        }
        else if datas[row]["type"] == 3{
           performSegueWithIdentifier("goto_broadreq", sender: self)
            
        }
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
