//
//  ViewController.swift
//  kingpinSwiftTestApplication
//
//  Created by Stanislaw Pankevich on 16/03/15.
//
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class Globe: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    var locManager = CLLocationManager()
    let latitude = CLLocationDegrees()
    let longitude = CLLocationDegrees()

    let reachability = Reachability.reachabilityForInternetConnection()

    
    private var clusteringController : KPClusteringController!

    var glimperid: String!
    var data: NSData?
    var json : JSON?

    @IBAction func unwindToSegueG (segue : UIStoryboardSegue) {
}

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

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var uisb: UISearchBar!
    
    
    // MARK: UIViewController

    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        reachability.startNotifier()
        
        // Initial reachability check
        if reachability.isReachable() {
            let algorithm : KPGridClusteringAlgorithm = KPGridClusteringAlgorithm()
            
            algorithm.annotationSize = CGSizeMake(25, 50)
            algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase;
            
            clusteringController = KPClusteringController(mapView: self.mapView)
            clusteringController.delegate = self
            dispatch_async(dispatch_get_main_queue()) {
                
                self.clusteringController.setAnnotations(self.annotations())
                
            }
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.requestWhenInUseAuthorization()
            locManager.startMonitoringSignificantLocationChanges()
            // Check if the user allowed authorization
            mapView.showsUserLocation = true
            //uisb.layer.zPosition = 9999;
        } else {
            let alertController = UIAlertController(title: "Glimp", message:
                "No Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }

        
    }
    
    func getannot(){
        dispatch_async(dispatch_get_main_queue()) {
            self.clusteringController.setAnnotations(self.annotations())
        }

    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=false;
        super.viewWillAppear(animated)
        
        reachability.startNotifier()
        
        // Initial reachability check
        if reachability.isReachable() {
            let algorithm : KPGridClusteringAlgorithm = KPGridClusteringAlgorithm()
            
            algorithm.annotationSize = CGSizeMake(25, 50)
            algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase;
            
            clusteringController = KPClusteringController(mapView: self.mapView)
            clusteringController.delegate = self
            getannot()
            var helloWorldTimer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector("getannot"), userInfo: nil, repeats: true)

            
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.requestWhenInUseAuthorization()
            locManager.startMonitoringSignificantLocationChanges()
            // Check if the user allowed authorization
            mapView.showsUserLocation = true
            //uisb.layer.zPosition = 9999;
        } else {
            let alertController = UIAlertController(title: "Glimp", message:
                "No Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }

    }
    
    
    // MARK: Fake annotation set
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goto_video") {
            let secondViewController = segue.destinationViewController as! GlimpView
            let ider = glimperid as String!
            secondViewController.glimpsid = ider
        }
    }

    func makeRequest(url : String, params : [String : String]?, completionHandler: (responseObject: JSON?, error: NSError?) -> ())  -> Request? {
        
        return Alamofire.request(.GET, url, parameters: params, encoding: .URL)
            .responseString { request, response, responseBody, error in completionHandler(
                responseObject:
                {
                    // JSON to return
                    var json : JSON?
                    if let response = responseBody {
                        // Parse the response to NSData
                        if let data = (response as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
                            json = JSON(data: data)
                        }
                    }
                    
                    return json
                    
                    }(), error: error)
        }
    }

    
    
    func annotations() -> [TestAnnotation] {
        var annotations: [TestAnnotation] = []
        let baseURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/globe.php")

        let pointData = NSData(contentsOfURL: baseURL!, options: nil, error: nil)

        let points = NSJSONSerialization.JSONObjectWithData(pointData!,
            options: nil,
            error: nil) as! NSDictionary


        for point in points["glimps"] as! NSArray {
            let lat = (point as! NSDictionary)["latitude"] as! CLLocationDegrees
            let lon = (point as! NSDictionary)["longitude"] as! CLLocationDegrees
            let gid = String(stringInterpolationSegment: (point as! NSDictionary)["id"]!)
            ///
            let coordinate1 : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
            
            let a1: TestAnnotation = TestAnnotation(coordinate: coordinate1, title: gid)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            annotations.append(a1)
            }
        }
        
            return annotations
        
        }
}

// MARK: <MKMapViewDelegate>

extension Globe : MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

        
        var annotationView : MKPinAnnotationView?
        
        if annotation is KPAnnotation {
            let a : KPAnnotation = annotation as! KPAnnotation
            
            if a.isCluster() {
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("cluster") as? MKPinAnnotationView
                
                if (annotationView == nil) {
                    annotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "cluster")
                }
                
                annotationView!.image =  UIImage(named:"marker1.png")
                
            }
                
            else {
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
                if (annotationView == nil) {
                    annotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "pin")
                }

                annotationView!.image =  UIImage(named:"marker.png")
            }
            
            annotationView!.canShowCallout = false;
        }
        
        return annotationView;
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        reachability.startNotifier()
        
        // Initial reachability check
        if reachability.isReachable() {
            clusteringController.refresh(true)

        } else {
            let alertController = UIAlertController(title: "Glimp", message:
                "No Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        }

    }
    
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if view.annotation is KPAnnotation {
            let cluster : KPAnnotation = view.annotation as! KPAnnotation
            
            if cluster.annotations.count > 1 {
                let region = MKCoordinateRegionMakeWithDistance(cluster.coordinate,
                    cluster.radius * 2.5,
                    cluster.radius * 2.5)
                
                mapView.setRegion(region, animated: true)
            }
            if cluster.annotations.count == 1{
                glimperid = view.annotation.title!
                self.performSegueWithIdentifier("goto_video", sender: self)

                
            }
        }
    }
}

// MARK: <CLControllerDelegate>

extension Globe : KPClusteringControllerDelegate {
    func clusteringControllerShouldClusterAnnotations(clusteringController: KPClusteringController!) -> Bool {
        return true
    }
}
