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
    
    
    

    @IBAction func unwindToSegueHome (segue : UIStoryboardSegue) {}
    
    @IBAction func zoomOut(sender: AnyObject) {
        var ladelta : CLLocationDegrees = 30
        var lndelta : CLLocationDegrees = 30
        let latitude = locManager.location.coordinate.latitude
        let longitude = locManager.location.coordinate.longitude
        
        var s:MKCoordinateSpan = MKCoordinateSpanMake(ladelta,lndelta)
        var l:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var reg:MKCoordinateRegion = MKCoordinateRegionMake(l, s)
        mapView.setRegion(reg, animated: true)
        
    }
    
    @IBAction func findMePressed(sender: AnyObject) {
        var ladelta : CLLocationDegrees = 0.01
        var lndelta : CLLocationDegrees = 0.01
        let latitude = locManager.location.coordinate.latitude
        let longitude = locManager.location.coordinate.longitude
        
        var s:MKCoordinateSpan = MKCoordinateSpanMake(ladelta,lndelta)
        var l:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var reg:MKCoordinateRegion = MKCoordinateRegionMake(l, s)
        mapView.setRegion(reg, animated: true)
    }

    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }

    
    let reachability = Reachability.reachabilityForInternetConnection()

    var currentRadius:CGFloat = 0.0
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
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
        
        let baseURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/home.php?username="+name!)
        //let baseURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/home.php?username=nassar")

        let pointData = NSData(contentsOfURL: baseURL!, options: nil, error: nil)
        
        let points = NSJSONSerialization.JSONObjectWithData(pointData!,
            options: nil,
            error: nil) as! NSDictionary

        for point in points["glimps"] as! NSArray {
            var a = JPSThumbnail()
            var imageurl=String(stringInterpolationSegment: (point as! NSDictionary)["profile_pic"]!)
            
            var url = NSURL(string: imageurl)
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            a.image = UIImage(data: data!)
                
            a.title =  String(stringInterpolationSegment: (point as! NSDictionary)["username"]!)
            a.subtitle =  String(stringInterpolationSegment: (point as! NSDictionary)["loc"]!)
            var lat = (point as! NSDictionary)["latitude"] as! CLLocationDegrees
            var lon = (point as! NSDictionary)["longitude"] as! CLLocationDegrees
            
            a.coordinate = CLLocationCoordinate2DMake(lat, lon)
            a.disclosureBlock = {
                self.glimperid = String(stringInterpolationSegment: (point as! NSDictionary)["id"]!)
                println(self.glimperid)

                self.performSegueWithIdentifier("goto_video", sender: self)

            }
            var a1: JPSThumbnailAnnotation = JPSThumbnailAnnotation(thumbnail: a)

                annotations.append(a1)

        }
        return annotations
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "glimplogo-2.png")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }

    func tap(){
        println("FIRED!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "glimp-logo")
        imageView.image = image
        navigationItem.titleView = imageView

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        NSUserDefaults.standardUserDefaults().objectForKey("deviceToken")
        
        //////////////////////////////////////
        reachability.startNotifier()
        
        // Initial reachability check
        if reachability.isReachable() {
            let location = CLLocationCoordinate2D(
                latitude: 51.50007773,
                longitude: -0.1246402
            )
            self.mapView = MKMapView(frame: view.bounds)
            self.mapView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
            self.mapView.delegate = self
            view.addSubview(self.mapView)
            view.sendSubviewToBack(self.mapView)
            
            let image = UIImage(named: "glimp-logo")
            navigationItem.titleView = UIImageView(image: image)
            
            self.tabBarController?.tabBar.hidden = false
            //Edge to feed to get the feed
            
            locManager.requestWhenInUseAuthorization()
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            UIApplication.sharedApplication().statusBarHidden=false;
            self.tabBarController?.tabBar.hidden = false
            let progressHUD = ProgressHUD(text: "Loading...")
            self.view.addSubview(progressHUD)

            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
            if (isLoggedIn != 1) {
                self.performSegueWithIdentifier("goto_login", sender: self)
                
            } else {
                let delayInSeconds = 0.01
                let popTime = dispatch_time(DISPATCH_TIME_NOW,
                    Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
                dispatch_after(popTime, GlobalMainQueue) { // 2
                    
                    self.mapView.addAnnotations(self.annotations())

                    progressHUD.removeFromSuperview()
                }
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

        self.mapView.addAnnotations(self.annotations())
        println("refreshed")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //1 grab current location
        var currentLocation = locations.last as! CLLocation
        //2 create location point for map based on current location
        var location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        //3 define layout for map
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let userPoint = MKCoordinateRegion(center: location, span: span)
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
    


    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {

        (view as? JPSThumbnailAnnotationViewProtocol)?.didSelectAnnotationViewInMap(mapView)

    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {

        (view as? JPSThumbnailAnnotationViewProtocol)?.didDeselectAnnotationViewInMap(mapView)

    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        return (annotation as? JPSThumbnailAnnotationProtocol)?.annotationViewInMap(mapView)
    }
    
    
}

