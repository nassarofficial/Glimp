//
//  BroadcastReq.swift
//  Glimp
//
//  Created by Ahmed Nassar on 7/17/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import Haneke
import SwiftyJSON
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class BroadcastReq: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    var gllatitude: Float = 0.0
    var gllongitude: Float = 0.0
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    private var clusteringController : KPClusteringController!

    
    var datas: [JSON] = []
    @IBOutlet weak var tablespinner: UIActivityIndicatorView!
    @IBOutlet weak var profilescroll: UIScrollView!
    var gllat: Float? = 0.0
    var gllon: Float? = 0.0
    var broadcast_id = ""
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var message: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var ppic: UIImageView!
    
    func getBroadcast(){
        self.tablespinner.hidden = false
    Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/broadcastreq.php", parameters: ["b_id": self.broadcast_id, "lat": gllatitude, "lon": gllongitude]).responseJSON { (request, response, json, error) in
        if json != nil {
            var jsonObj = JSON(json!)
            println(request)
                println(jsonObj["broadcastreq"]["distance"])
                self.username.text = jsonObj["broadcastreq"][0]["username"].string
                self.message.text = jsonObj["broadcastreq"][0]["message"].string
               // self.distance.text = jsonObj["broadcastreq"]["distance"].string

                self.latitude = jsonObj["broadcastreq"][0]["latitude"].doubleValue as CLLocationDegrees
                self.longitude = jsonObj["broadcastreq"][0]["longitude"].doubleValue as CLLocationDegrees

                if let urlString = jsonObj["broadcastreq"][0]["ppic"].string{
                    let url = NSURL(string: urlString)
                    println(url)
                    let imageSize = 54 as CGFloat
                    self.ppic.frame.size.height = imageSize
                    self.ppic.frame.size.width  = imageSize
                    self.ppic.layer.cornerRadius = imageSize / 2.0
                    self.ppic.clipsToBounds = true
                    
                    self.ppic.hnk_setImageFromURL(url!)
                }
                }
        var ladelta : CLLocationDegrees = 0.001
        var lndelta : CLLocationDegrees = 0.001
        let latitude2 = self.latitude
        let longitude2 = self.longitude
        
        var s:MKCoordinateSpan = MKCoordinateSpanMake(ladelta,lndelta)
        var l:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude2, longitude2)
        var reg:MKCoordinateRegion = MKCoordinateRegionMake(l, s)
        self.mapView.setRegion(reg, animated: true)

        self.tablespinner.hidden = true
        var info1 = CustomPointAnnotation()
        info1.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        println(self.latitude)
        println(self.longitude)
        info1.title = "Location Request"
        info1.subtitle = ""
        info1.imageName = "marker.png"
        self.mapView.addAnnotation(info1)

        }

    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude)
//        self.gllatitude = Float(userLocation.coordinate.latitude)
//        self.gllongitude = Float(userLocation.coordinate.longitude)
        let width = 50000.0 // meters
        let height = 50000.0
        let region = MKCoordinateRegionMakeWithDistance(center, width, height)
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
        })
        
        //1 grab current location
        var currentLocation = locations.last as! CLLocation
        //2 create location point for map based on current location
        var location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        //3 define layout for map
        locationManager.stopUpdatingLocation()
        gllatitude = Float(currentLocation.coordinate.latitude)
        gllongitude = Float(currentLocation.coordinate.longitude)
        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/distance.php", parameters: ["b_id": self.broadcast_id, "lat": self.gllatitude, "lon": self.gllongitude]).responseJSON { (request, response, json, error) in
            if json != nil {
                var jsonObj = JSON(json!)
                println(request)
//                println(jsonObj["distance"][0]["distance"])
                self.distance.text = jsonObj["distance"][0]["distance"].string

                
            }
            
            
        }
//
//        println(self.gllatitude)
//        println(self.gllongitude)
//
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let algorithm : KPGridClusteringAlgorithm = KPGridClusteringAlgorithm()
        
        algorithm.annotationSize = CGSizeMake(25, 50)
        algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase;

        clusteringController = KPClusteringController(mapView: self.mapView)

        mapView.setUserTrackingMode(.Follow, animated: true)
        automaticallyAdjustsScrollViewInsets = false
        
                    self.getBroadcast()

        
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goto_vid") {
            let secondViewController = segue.destinationViewController as! Glimp
            let ider = self.broadcast_id as String!
            secondViewController.broadcast_id = ider
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView.image = UIImage(named:cpa.imageName)
        
        return anView
    }
}
