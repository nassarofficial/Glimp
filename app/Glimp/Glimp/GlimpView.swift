//
//  GlimpView.swift
//  GLIMP
//
//  Created by Ahmed Nassar on 5/15/15.
//  Copyright (c) 2015 glimp. All rights reserved.
//

import UIKit
import MediaPlayer

class GlimpView: UIViewController{
    var glimpsid:String!
    var ViewControllerVideoPath = ""
    var moviePlayer : MPMoviePlayerController?
    var prefs = NSUserDefaults.standardUserDefaults()
    var usernamep : String = ""
    var userid: String = ""
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var locid : String = ""
    var loc : String = ""
    var hrs : String = ""
    var min : String = ""
    var timestart : String = ""
    var timeend : String = ""
    
    @IBOutlet weak var timeleft: UILabel!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var labeler: UILabel!
    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var gdescription: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var backbutton: UIButton!
    
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var gplayer: UIView!
    @IBOutlet weak var comments: UIButton!
    
    @IBOutlet weak var bacbutton: UIBarButtonItem!
    @IBOutlet weak var navigation: UINavigationBar!
    @IBAction func gotoglobe(sender: AnyObject) {
        println("hello")
    }
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    @IBAction func unwindToSeguer (segue : UIStoryboardSegue) {}

    // MARK: object lifecycle
    
    //    override init() {
    //        super.init()
    //    }
    //
    func setupView() {
        // Visual feedback to the user, so they know we're busy loading an image
        spinner.center = CGPoint(x: view.center.x, y: view.center.y - view.bounds.origin.y / 2.0)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
        
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goto_comment") {
            let secondViewController = segue.destinationViewController as! Comments
            
            let ider = glimpsid as String!
            let ider2 = usernamep as String!
          //  println(ider2)

            secondViewController.glimpid = ider
            secondViewController.user_id = ider2

        }
        if (segue.identifier == "goto_location") {
            let secondViewController = segue.destinationViewController as! LocationCollectionViewController
            secondViewController.locid = self.locid
        
            secondViewController.loc = self.loc

        }
        if (segue.identifier == "goto_userprofile") {
            let secondViewController = segue.destinationViewController as! UserProfile
            let ider = userid as String!

            let ider2 = usernamep as String!
            //println(ider2)
            secondViewController.userid = ider

            secondViewController.username = ider2
            
        }

    }


    func getglimps(){
        setupView()
        println(self.glimpsid)
        self.spinner.stopAnimating()

        let baseURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/glimp.php?glimpid="+self.glimpsid!)
        
        let pointData = NSData(contentsOfURL: baseURL!, options: nil, error: nil)
        
        let points = NSJSONSerialization.JSONObjectWithData(pointData!,
            options: nil,
            error: nil) as! NSDictionary
        
        
        for point in points["glimp"] as! NSArray {
            self.ViewControllerVideoPath = (point as! NSDictionary)["filename"] as! String
            self.username.setTitle((point as! NSDictionary)["username"] as? String, forState: UIControlState.Normal)
            self.usernamep = String(stringInterpolationSegment: (point as! NSDictionary)["username"]!) as String
            self.gdescription.text = (point as! NSDictionary)["description"] as? String
            
            self.userid = String(stringInterpolationSegment: (point as! NSDictionary)["userid"]!) as String
            
            let com = String(stringInterpolationSegment: (point as! NSDictionary)["COMMENT"]!) as String
            self.comments.setTitle(com, forState: UIControlState.Normal)
            self.views.text = String(stringInterpolationSegment: (point as! NSDictionary)["views"]!) as String
            self.locid = String(stringInterpolationSegment: (point as! NSDictionary)["locid"]!) as String
            
            self.loc = String(stringInterpolationSegment: (point as! NSDictionary)["loc"]!) as String
            self.timestart = String(stringInterpolationSegment: (point as! NSDictionary)["time"]!) as String
            self.timeend = String(stringInterpolationSegment: (point as! NSDictionary)["stoptime"]!) as String
            
            self.location.setTitle(loc, forState: UIControlState.Normal)
            
        }
        
        let url = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/"+self.ViewControllerVideoPath)
        
        //println(url)
        
        self.moviePlayer = MPMoviePlayerController(contentURL: url)
        
        
        if let player = moviePlayer {
            
            player.view.frame = CGRect(x: 0, y: 44, width: self.view.bounds.width, height: 275)
            player.prepareToPlay()
            player.scalingMode = .AspectFill
            self.mainview.addSubview(player.view)
            
            //            self.mainview.sendSubviewToBack(self.gplayer)
            //            self.mainview.bringSubviewToFront(player.view)
            //            self.mainview.bringSubviewToFront(self.navigation)
            //            player.view.layer.zPosition = 1;
            //            navigation.layer.zPosition = 9999;
            
        }

    }
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        getglimps()
        getdate()
    }
    
    func getdate(){
        let startdate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: startdate)
        let hour = components.hour
        let minutes = components.minute
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "Cairo");

        let enddate = dateFormatter.dateFromString("2015-06-19 18:52:56")
        let calendars = NSCalendar.currentCalendar()
        let componentss = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: enddate!)
        let hours = componentss.hour
        let minutess = componentss.minute
        
        let componentsss = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: startdate, toDate: enddate!, options: nil)
        
        if componentsss.hour == 0{
            println(String(componentsss.minute))
        }
        else {
            if componentsss.hour == 1{
                timeleft.text = (String(componentsss.hour) + " hr " + String(componentsss.minute) + " mins")
            }
            else {
                timeleft.text = (String(componentsss.hour) + " hrs " + String(componentsss.minute) + " mins")
            }
        }
    }


    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=true;
        self.tabBarController?.tabBar.hidden = true
        let userCalendar = NSCalendar.currentCalendar()
        let dateMakerFormatter = NSDateFormatter()
        dateMakerFormatter.calendar = userCalendar
        
        dateMakerFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .MediumStyle)

        var startTime = dateMakerFormatter.dateFromString(timestart)
        var endTime = dateMakerFormatter.dateFromString(timeend)
        
        let hourMinuteComponents: NSCalendarUnit = .CalendarUnitHour | .CalendarUnitMinute
        
        let timeDifference = userCalendar.components(hourMinuteComponents,fromDate: startTime!,toDate: endTime!,options: nil)
        
        println(timeDifference.hour)
        println(timeDifference.minute)
        
        timeleft.text = String(timeDifference.hour) + " hrs " + String(timeDifference.minute) + " mins "

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
