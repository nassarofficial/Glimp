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
import ActiveLabel
import FBSDKShareKit
import FBSDKCoreKit

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
    
    @IBOutlet var textView: ActiveLabel?
    
    @IBOutlet weak var descindicator: UIActivityIndicatorView!
    @IBOutlet weak var vidindicator: UIActivityIndicatorView!
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var gplayer: UIView!
    @IBOutlet weak var comments: UIButton!
    
    @IBOutlet weak var bacbutton: UIBarButtonItem!
    @IBOutlet weak var navigation: UINavigationBar!
    @IBAction func gotoglobe(sender: AnyObject) {
    }
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    @IBAction func unwindToSegueprofile (segue : UIStoryboardSegue) {}

    @IBAction func unwindToSeguer (segue : UIStoryboardSegue) {}
    @IBOutlet var vidreply: UIButton!

    
    @IBAction func share(sender: AnyObject) {
        let firstActivityItem = "Check out whats happening at " + self.loc + " on Glimp. " + "http://www.glimpglobe.com/video.php?id="+glimpsid

        weak var postImage: UIImageView!

        var activityItems: [AnyObject]?
        
        let image = postImage.image
        activityItems = [firstActivityItem, postImage.image!]

        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
//        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)

        self.presentViewController(activityViewController, animated: true, completion: nil)
//        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
//
//        let imagerURLer =  "http://www.glimpglobe.com/thumbnail/"+self.ViewControllerVideoPath
//        let contentURLer: String = "http://www.glimpglobe.com/video.php?id="+glimpsid
//        print(imagerURLer)
//        print(contentURLer)
//        content.contentURL = NSURL(string: contentURLer)
//        content.contentTitle = self.loc
//        content.contentDescription = self.textView!.text
//        content.imageURL = NSURL(string: imagerURLer)
//        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)

    }

    @IBOutlet var reportbut: UIButton!
    @IBOutlet var deletebut: UIButton!
    @IBAction func deleteGlimp(sender: AnyObject) {
        let alert = UIAlertController(title: "Delete Glimp", message: "Are you sure you want to delete this glimp?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                Alamofire.request(.POST, "http://glimpglobe.com/v2/deleteGlimp.php", parameters: ["g_id": self.glimpsid, "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"]).responseJSON { response in
                    // println(response)
                }
                self.performSegueWithIdentifier("unwinder", sender: self)

            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)


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
            let stringer =  payloader
            let ider2 = stringer as String!
            //println(ider2)
            //  secondViewController.userid = idergoto_report
            
            secondViewController.loc = ider2
        }
        if (segue.identifier == "goto_report") {
            let secondViewController = segue.destinationViewController as! Report
            //  let ider = userid as String!
            let glimp =  glimpsid
            let ider2 = glimp
                as String!
            //println(ider2)
            //  secondViewController.userid = idergoto_report
            
            secondViewController.glimpid = ider2
        }


    }


    func getglimps(){
        setupView()

        
        Alamofire.request(.POST, "http://glimpglobe.com/v2/glimp.php", parameters: ["secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y", "glimpid" : self.glimpsid!])
            .responseJSON { response in
                
                //print(response.result.value as! String)
                if let points = response.result.value {
                    if (points["glimp"] == nil || points["glimp"]!!.count == 0){
                        let alert = UIAlertController(title: "Glimp Not Found", message: "The Glimp requested is not available.", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                            switch action.style{
                            case .Default:
                                self.performSegueWithIdentifier("unwinder", sender: self)
                                
                            case .Cancel:
                                self.performSegueWithIdentifier("unwinder", sender: self)
                                
                            case .Destructive:
                                self.performSegueWithIdentifier("unwinder", sender: self)
                            }
                        }))

                    } else {
                        
                    for point in points["glimp"] as! NSArray {
                        self.ViewControllerVideoPath = (point as! NSDictionary)["filename"] as! String
                        self.username.setTitle((point as! NSDictionary)["username"] as? String, forState: UIControlState.Normal)
                        self.usernamep = String(stringInterpolationSegment: (point as!NSDictionary)["username"]!) as String
                        print((point as! NSDictionary)["description"] as? String)
                        self.textView!.text = (point as! NSDictionary)["description"] as? String
                        self.textView!.hashtagColor = UIColor(red: 0.247, green: 0.933, blue: 1, alpha: 1)
                        self.textView!.mentionColor = UIColor(red: 0.247, green: 0.933, blue: 1, alpha: 1)

                        self.textView!.numberOfLines = 3
                        self.textView!.handleHashtagTap { hashtag in
                            print("Success. You just tapped the \(hashtag) hashtag")
                            self.payloader = hashtag
                            self.performSegueWithIdentifier("goto_hash", sender: self)
                        }
                        self.textView!.handleMentionTap { userHandle in
                            print("Success. You just tapped the \(userHandle) hashtag")
                            self.payloader = userHandle
                            self.performSegueWithIdentifier("goto_userprofilemention", sender: self)
                        }

                       // self.textView.resolveHashTags()
                        
                        self.userid = String(stringInterpolationSegment: (point as! NSDictionary)["userid"]!) as String
                        
                        let com = String(stringInterpolationSegment: (point as! NSDictionary)["COMMENT"]!) as String
                        self.comments.setTitle(com, forState: UIControlState.Normal)
                        self.views.text = String(stringInterpolationSegment: (point as! NSDictionary)["views"]!) as String
                        self.locid = String(stringInterpolationSegment: (point as! NSDictionary)["locid"]!) as String
                        
                        self.loc = String(stringInterpolationSegment: (point as! NSDictionary)["loc"]!) as String
                        self.timestart = String(stringInterpolationSegment: (point as! NSDictionary)["time"]!) as String
                        self.timeend = String(stringInterpolationSegment: (point as! NSDictionary)["stoptime"]!) as String
                        self.broadcat_id = String(stringInterpolationSegment: (point as! NSDictionary)["b_id"]!) as String
                        
                        self.location.setTitle(self.loc, forState: UIControlState.Normal)
                        if (self.broadcat_id == "0"){
                            self.vidreply.hidden = true
                        } else {
                            self.vidreply.hidden = false
                        }
                        let startdate = NSDate()
                        let calendar = NSCalendar.currentCalendar()
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "Cairo");
                        
                        let enddate = dateFormatter.dateFromString(self.timeend)
                        let componentsss = calendar.components([.Hour, .Minute], fromDate: startdate, toDate: enddate!, options: [])
                        
                        if componentsss.hour == 0{
                            print(String(componentsss.minute))
                        }
                        else {
                            if componentsss.hour == 1{
                                self.timeleft.text = (String(componentsss.hour) + " hr " + String(componentsss.minute) + " mins")
                            }
                            else {
                                self.timeleft.text = (String(componentsss.hour) + " hrs " + String(componentsss.minute) + " mins")
                            }
                        }

                    }
                    }

                    self.spinner.stopAnimating()

                    let url = NSURL(string: "http://glimpglobe.com/"+self.ViewControllerVideoPath)
                    
                    //println(url)
                    
                    self.moviePlayer = MPMoviePlayerController(contentURL: url)
                    
                    
                    if let player = self.moviePlayer {
                        
                        player.view.frame = CGRect(x: 0, y: 44, width: self.view.bounds.width, height: 275)
                        player.prepareToPlay()
                        player.scalingMode = .AspectFill
                        self.mainview.addSubview(player.view)
                        
                    }
                    
                }
                
                }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        vidreply.hidden = false
//        vidindicator.hidden = false
//        descindicator.hidden = false

        dispatch_async(dispatch_get_main_queue()) { // 2

            self.getglimps()

            self.vidindicator.hidden = true

            self.descindicator.hidden = true
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
        
        Alamofire.request(.POST, "http://glimpglobe.com/v2/views.php", parameters: ["gid": glimpsid, "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"]).responseJSON { (request) in
           // println(response)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
