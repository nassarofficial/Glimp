//
//  HomeVC.swift
//  SwiftLoginScreen
//
//  Created by Dipin Krishna on 31/07/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.

import UIKit
import MapKit
import CoreLocation
import Haneke
import Alamofire

private enum SideViewState {
    case Hidden
    case Showing
}

class HomeVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var locManager = CLLocationManager()
    let latitude = CLLocationDegrees()
    let longitude = CLLocationDegrees()
    var userLocation: CLLocationCoordinate2D?
    var imageView: UIImageView!
    @IBOutlet weak var navbar: UINavigationBar!
    var glimperid : String = ""
    var mapView: MKMapView!
    
    var later = ""
    var longer = ""
    

    @IBAction func unwindToSegueHome (segue : UIStoryboardSegue) {}
    
    @IBAction func zoomOut(sender: AnyObject) {
        let ladelta : CLLocationDegrees = 30
        let lndelta : CLLocationDegrees = 30
        let latitude = locManager.location!.coordinate.latitude
        let longitude = locManager.location!.coordinate.longitude
        
        let s:MKCoordinateSpan = MKCoordinateSpanMake(ladelta,lndelta)
        let l:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let reg:MKCoordinateRegion = MKCoordinateRegionMake(l, s)
        mapView.setRegion(reg, animated: true)
        
    }
    
    @IBAction func findMePressed(sender: AnyObject) {
        let ladelta : CLLocationDegrees = 0.01
        let lndelta : CLLocationDegrees = 0.01
        let latitude = locManager.location!.coordinate.latitude
        let longitude = locManager.location!.coordinate.longitude
        
        let s:MKCoordinateSpan = MKCoordinateSpanMake(ladelta,lndelta)
        let l:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let reg:MKCoordinateRegion = MKCoordinateRegionMake(l, s)
        mapView.setRegion(reg, animated: true)
    }

    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    func getBroadcast(){
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        let usernamep = String(name!)
        
        
        Alamofire.request(.POST, "http://glimpglobe.com/v2/broadcast.php", parameters:[
            "username": usernamep,
            "lat": String(locManager.location!.coordinate.latitude),
            "long": String(locManager.location!.coordinate.longitude),
            "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"
            ])
            .response { (request, response, data, error) in
                
        }
        
    }

    
    let reachability = Reachability.reachabilityForInternetConnection()

    var currentRadius:CGFloat = 0.0
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goto_video") {
            let secondViewController = segue.destinationViewController as! GlimpView
            let ider = glimperid as String!
            secondViewController.glimpsid = ider
        }
    }

    func annotations() -> [JPSThumbnailAnnotation] {

        var annotations: [JPSThumbnailAnnotation] = []
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        let progressHUD = ProgressHUD(text: "Loading...")
        self.view.addSubview(progressHUD)
        
        Alamofire.request(.POST, "http://glimpglobe.com/v2/home.php", parameters: ["username": name!, "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"])
            .responseJSON { response in
                if let points = response.result.value {
                
                    for point in points["glimps"] as! NSArray {

                        let a = JPSThumbnail()
                        let imageurl=String(stringInterpolationSegment: (point as! NSDictionary)["profile_pic"]!)
                        if let url = NSURL(string: imageurl) {
                            if let data = NSData(contentsOfURL: url){
                                a.image = UIImage(data: data)
                            }
                            
                        } else {
                            let url = NSURL(string: "http://glimpglobe.com/profilepic.jpeg")
                            let data = NSData(contentsOfURL: url!)
                            a.image = UIImage(data: data!)
                        }
                        
                        //                var url = NSURL(string: imageurl)
                        //                //println(url)
                        //                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                        //                a.image = UIImage(data: data!)
                        
                        
                        a.title =  String(stringInterpolationSegment: (point as! NSDictionary)["username"]!)
                        a.subtitle =  String(stringInterpolationSegment: (point as! NSDictionary)["loc"]!)
                        let lat = (point as! NSDictionary)["latitude"] as! CLLocationDegrees
                        let lon = (point as! NSDictionary)["longitude"] as! CLLocationDegrees
                        
                        a.coordinate = CLLocationCoordinate2DMake(lat, lon)
                        
                        a.disclosureBlock = {
                            self.glimperid = String(stringInterpolationSegment: (point as! NSDictionary)["id"]!)
                            
                            self.performSegueWithIdentifier("goto_video", sender: self)
                            
                        }
                        let a1: JPSThumbnailAnnotation = JPSThumbnailAnnotation(thumbnail: a)
                        
                        annotations.append(a1)
                        
                    }
                    self.mapView.addAnnotations(annotations)

                
                }
                progressHUD.removeFromSuperview()

        }
        return annotations


    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "glimp-logo")
        imageView.image = image
        navigationItem.titleView = imageView

        NSUserDefaults.standardUserDefaults().objectForKey("deviceToken")
        
        //////////////////////////////////////
        reachability!.startNotifier()
        
        // Initial reachability check
        if reachability!.isReachable() {
            self.mapView = MKMapView(frame: view.bounds)
            self.mapView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            self.mapView.delegate = self
            view.addSubview(self.mapView)
            view.sendSubviewToBack(self.mapView)
            
//            let image = UIImage(named: "glimp-logo")
//            navigationItem.titleView = UIImageView(image: image)
            
            self.tabBarController?.tabBar.hidden = false
            //Edge to feed to get the feed
            
            locManager.requestWhenInUseAuthorization()
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            UIApplication.sharedApplication().statusBarHidden=false;
            self.tabBarController?.tabBar.hidden = false
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int

            if (isLoggedIn != 1) {
                self.performSegueWithIdentifier("goto_login", sender: self)

            } else {
                
//                let delayInSeconds = 0.01
//                let popTime = dispatch_time(DISPATCH_TIME_NOW,
//                    Int64(delayInSeconds * Double(NSEC_PER_SEC)))
//
//
//                dispatch_after(popTime, GlobalMainQueue) { // 2
                

                    self.annotations()


//                }
                var updateTimer = NSTimer.scheduledTimerWithTimeInterval(120.0, target: self, selector: "refresher", userInfo: nil, repeats: true)

            }
            

            
        } else {
            let alertController = UIAlertController(title: "Glimp", message:
                "No Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    

    
    
    func refresher(){
        let delayInSeconds = 0.01
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
        dispatch_after(popTime, GlobalMainQueue) { // 2
            var updateTimer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: "getBroadcast", userInfo: nil, repeats: true)

        self.annotations()
        print("refreshed")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locManager.stopUpdatingLocation()
        
    }
    
    
    
    
    // Reverse GeoCode Function to extract address from current Location
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=false;

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    


    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {

        (view as? JPSThumbnailAnnotationViewProtocol)?.didSelectAnnotationViewInMap(mapView)

    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {

        (view as? JPSThumbnailAnnotationViewProtocol)?.didDeselectAnnotationViewInMap(mapView)

    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return (annotation as? JPSThumbnailAnnotationProtocol)?.annotationViewInMap(mapView)
    }
    
    
}

