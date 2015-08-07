//
//  SendBroadcast.swift
//  Glimp
//
//  Created by Ahmed Nassar on 7/21/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Haneke
import MapKit
import Alamofire

class SendBroadcast: UIViewController {

    @IBOutlet var ppic: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var message: UITextField!
    var newCoord:CLLocationCoordinate2D!
    
    var profilepic: String = ""
    @IBOutlet var viewblock: UIView!
    var lat : Float = 0.00
    var long : Float = 0.00
    let annotation = MKPointAnnotation()

    func textField(message: UITextView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(message.text.utf16) + count(string.utf16) - range.length
        return newLength <= 110 // Bool
    }
    
    @IBAction func sendRequest(sender: AnyObject) {
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        var usernamep = String(name!)

        let parameters = [
            "username": usernamep,
            "lat": lat ,
            "long": long
        ]

        Alamofire.request(.POST, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/sendBroadcast.php", parameters: parameters as? [String : AnyObject])
            .response { (request, response, data, error) in
            //    println(response)
                self.performSegueWithIdentifier("unwindToSegueGer", sender: nil)
     
        }

    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        username.text = name
        let baseURL1 = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/profilepic.php?username="+name!)
        let pointData1 = NSData(contentsOfURL: baseURL1!, options: nil, error: nil)
        let points1 = NSJSONSerialization.JSONObjectWithData(pointData1!,
            options: nil,
            error: nil) as! NSDictionary
        for point1 in points1["profilepic"] as! NSArray {
            self.profilepic = String(stringInterpolationSegment: (point1 as! NSDictionary)["profile_pic"]!)
        }
        println("hello")
        if profilepic == "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/profilepic.jpeg"{
            ppic.image = UIImage(named: "add_photo-1");
        }
        else {
            println(profilepic)
            let url = NSURL(string: profilepic)

            var imageSize = 54 as CGFloat
            self.ppic.frame.size.height = imageSize
            self.ppic.frame.size.width  = imageSize
            self.ppic.layer.cornerRadius = imageSize / 2.05
            self.ppic.clipsToBounds = true
            
            ppic.hnk_setImageFromURL(url!)
            
        }


        annotation.coordinate = newCoord
        annotation.title = "Broadcast Request"
        annotation.subtitle = ""
        lat = Float(annotation.coordinate.latitude)
        long = Float(annotation.coordinate.latitude)

        self.mapView.addAnnotation(annotation)
        var ladelta : CLLocationDegrees = 0.1
        var lndelta : CLLocationDegrees = 0.1

        var s:MKCoordinateSpan = MKCoordinateSpanMake(ladelta,lndelta)
        var reg:MKCoordinateRegion = MKCoordinateRegionMake(newCoord, s)
        self.mapView.setRegion(reg, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .Purple
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = false
            lat = Float(annotation.coordinate.latitude)
            long = Float(annotation.coordinate.longitude)
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
//        switch (newState) {
//        case .Starting:
//            view.dragState = .Dragging
//            println("moved")
//        case .Ending, .Canceling:
//            println("end")
//
//            view.dragState = .None
//        default: break
        lat = Float(annotation.coordinate.latitude)
        long = Float(annotation.coordinate.longitude)

        //}
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
