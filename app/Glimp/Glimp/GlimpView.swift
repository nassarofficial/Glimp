//
//  GlimpView.swift
//  GLIMP
//
//  Created by Ahmed Nassar on 5/15/15.
//  Copyright (c) 2015 glimp. All rights reserved.
//

import UIKit
import MediaPlayer
import Alamofire

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
    var broadcat_id = ""
    var payloader = ""
    @IBOutlet weak var timeleft: UILabel!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var labeler: UILabel!
    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var backbutton: UIButton!
    
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var descindicator: UIActivityIndicatorView!
    @IBOutlet weak var vidindicator: UIActivityIndicatorView!
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
    @IBOutlet var vidreply: UIButton!

    @IBOutlet var reportbut: UIButton!
    @IBOutlet var deletebut: UIButton!
    @IBAction func deleteGlimp(sender: AnyObject) {
       
        Alamofire.request(.POST, "/http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/deleteGlimp.php", parameters: ["g_id": glimpsid]).responseJSON { (request, response, json, error) in
            // println(response)
        }
        performSegueWithIdentifier("unwinder", sender: self)

    }
    
    
    
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
            //  secondViewController.userid = idergoto_report
            
            secondViewController.loc = ider2
        }
        if (segue.identifier == "goto_report") {
            let secondViewController = segue.destinationViewController as! Report
            //  let ider = userid as String!
            var glimp =  glimpsid
            let ider2 = glimp
                as String!
            //println(ider2)
            //  secondViewController.userid = idergoto_report
            
            secondViewController.glimpid = ider2
        }


    }


    func getglimps(){
        setupView()
        //println(self.glimpsid)
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
            self.textView.text = (point as! NSDictionary)["description"] as? String
            textView.resolveHashTags()

            self.userid = String(stringInterpolationSegment: (point as! NSDictionary)["userid"]!) as String
            
            let com = String(stringInterpolationSegment: (point as! NSDictionary)["COMMENT"]!) as String
            self.comments.setTitle(com, forState: UIControlState.Normal)
            self.views.text = String(stringInterpolationSegment: (point as! NSDictionary)["views"]!) as String
            self.locid = String(stringInterpolationSegment: (point as! NSDictionary)["locid"]!) as String
            
            self.loc = String(stringInterpolationSegment: (point as! NSDictionary)["loc"]!) as String
            self.timestart = String(stringInterpolationSegment: (point as! NSDictionary)["time"]!) as String
            self.timeend = String(stringInterpolationSegment: (point as! NSDictionary)["stoptime"]!) as String
            self.broadcat_id = String(stringInterpolationSegment: (point as! NSDictionary)["b_id"]!) as String

            self.location.setTitle(loc, forState: UIControlState.Normal)
            if (broadcat_id == "0"){
                vidreply.hidden = true
            } else {
                vidreply.hidden = false
            }

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
        vidindicator.hidden = false
        descindicator.hidden = false
        super.viewDidLoad()
        vidreply.hidden = false
        dispatch_async(dispatch_get_main_queue()) { // 2

        self.getglimps()
            self.vidindicator.hidden = true

            self.getdate()
            self.descindicator.hidden = true
        }
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

        let enddate = dateFormatter.dateFromString(self.timeend)
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
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        
        if (name == usernamep){
            deletebut.hidden = false
            reportbut.hidden = true
        } else {
            deletebut.hidden = true
            reportbut.hidden = false
        }
        
        Alamofire.request(.POST, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/views.php", parameters: ["gid": glimpsid]).responseJSON { (request, response, json, error) in
           // println(response)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension GlimpView : UITextViewDelegate {
    
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
