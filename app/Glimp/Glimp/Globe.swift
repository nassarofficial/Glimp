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


class Usercell: UITableViewCell {
    @IBOutlet weak var labelCaption: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var descriptionCap: UILabel!
    
}
class QuesReqAnnot: MKPointAnnotation {
    var imageName: String!
}

class Globe: UIViewController,UITableViewDataSource, UITableViewDelegate,MKMapViewDelegate, CLLocationManagerDelegate {
    var locManager = CLLocationManager()
    let latitude = CLLocationDegrees()
    let longitude = CLLocationDegrees()
    @IBAction func unwindToSegueprof (segue : UIStoryboardSegue) {}
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {}
    @IBAction func unwindToSeguer (segue : UIStoryboardSegue) {}
    
    @IBOutlet weak var searchicon: UIImageView!
    @IBOutlet weak var searcher: UITextField!
    let reachability = Reachability.reachabilityForInternetConnection()
    
    var newCoord:CLLocationCoordinate2D!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topbar: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmenter: UISegmentedControl!
    
    
    @IBAction func droppin(gestureRecognizer:UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.locationInView(mapView)
        newCoord = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        performSegueWithIdentifier("push_request", sender: self)

    }
    
    @IBOutlet weak var usersearcher: UIView!
    @IBOutlet weak var segmentedcontrol: UIView!
    
    private var clusteringController : KPClusteringController!
    
    var glimperid: String!
    var data: NSData?
    var json : JSON?
    var annoation=MKPointAnnotation()
    var datas: [JSON] = []
    var locLabel = ""
    var locID = ""
    var segmentindex = 0
    var gid = ""
    var gusername = ""
    
    
    // Indicators
    
    @IBOutlet weak var nores: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func unwindToSegueprod (segue : UIStoryboardSegue) {}
    
    @IBAction func unwindToSegueG (segue : UIStoryboardSegue) {
    }
    @IBAction func cancelbutton(sender: AnyObject) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        
        
        self.mapView.removeAnnotation(annoation)
        segmentedcontrol.hidden = true
        self.searcher.text = "Search";
        searchicon.hidden = false
        self.searcher.textAlignment = NSTextAlignment.Center
        self.usersearcher.hidden = true
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        self.datas = []
        self.tableView.reloadData()
        self.datas = []
        
        if(segmenter.selectedSegmentIndex == 0)
        {
            segmentindex = 0;
            usersearcher.hidden = true
            self.datas = []
            self.tableView.reloadData()
            self.datas = []
            
        }
        else if(segmenter.selectedSegmentIndex == 1)
        {
            self.datas = []
            print(segmenter.selectedSegmentIndex)
            segmentindex = 1;
            usersearcher.hidden = false
            self.datas = []
            self.tableView.reloadData()
            self.datas = []
        }
        else if(segmenter.selectedSegmentIndex == 2)
        {
            
            segmentindex = 2;
            usersearcher.hidden = false
            self.datas = []
            self.tableView.reloadData()
            self.datas = []
            
        }
        else if(segmenter.selectedSegmentIndex == 3)
        {
            
            segmentindex = 3;
            usersearcher.hidden = false
            self.datas = []
            self.tableView.reloadData()
            self.datas = []
            
        }
        
    }
    
    
    func textFieldShouldReturn(searcher: UITextField!) -> Bool {   //delegate method
        searcher.resignFirstResponder()
        spinner.hidden=false
        if segmentindex == 0 {
            usersearcher.hidden = true
            let geocoder=CLGeocoder()
            
            geocoder.geocodeAddressString(searcher.text!, completionHandler:
                { (placemarks, error) -> Void in
                    
                    if (error != nil) {
                        print("failed with error" + error!.localizedDescription)
                        return
                    }
                    
                    
                    let placemark:CLPlacemark=placemarks![0] as CLPlacemark
                    let location:CLLocationCoordinate2D=placemark.location!.coordinate
                    
                    self.annoation.coordinate=location
                    self.annoation.title=self.searcher.text
                    self.mapView.addAnnotation(self.annoation)
                    
                    var mr:MKMapRect=self.mapView.visibleMapRect
                    let pt:MKMapPoint=MKMapPointForCoordinate(self.annoation.coordinate)
                    mr.origin.x=pt.x-mr.size.width*0.5
                    mr.origin.y=pt.y-mr.size.height*0.25
                    
                    self.mapView.setVisibleMapRect(mr, animated: true)
                    self.spinner.hidden = true

            })
            
        }
        else if segmentindex == 1 {
            self.datas = []
            usersearcher.hidden = false
            let sende: String = self.searcher.text!
            
            
            let escapedAddress = sende.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url = "https://api.foursquare.com/v2/venues/search?intent=global&query="+escapedAddress!+"&client_id=DPUDNKBQKC12FJ0KBRLVU5BG4JREZV1YAIVRXIULPLFZHMAL&client_secret=PA0I5FS3JWPDMOL0H5XLQNDJYBJPGNOEP4QX1ML23YOFGZ3G&v=20140806"
            
            Alamofire.request(.GET, url)
                .responseJSON { response in
                    
                    if let json = response.result.value {
                        var jsonObj = JSON(json)
                        if let data = jsonObj["response"]["venues"].arrayValue as [JSON]?{
                            self.datas = data
                            //println(self.datas) http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/search.php?scope=users&term=nassar
                            self.spinner.hidden = true
                            self.tableView.reloadData()
                        }
                    }else {
                        self.nores.hidden = true
                        self.tableView.reloadData()
                    }
            }

            self.datas = []

            
        }
        else if segmentindex == 2{
            usersearcher.hidden = false
            // spinnerblock.hidden=false
            self.datas = []
            let escapedAddress = self.searcher.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            let url = "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/v2/search.php?scope=users&secid=taB5hzwuWQdLCK%47Z7uj$vR%c2Q+UxEj?x9BS*-&term="+escapedAddress!
            
            Alamofire.request(.GET, url)
                .responseJSON { response in
                    
                    if let json = response.result.value {
                        var jsonObj = JSON(json)
                        if let data = jsonObj["search"].arrayValue as [JSON]?{
                            self.datas = data
                            //println(self.datas) http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/search.php?scope=users&term=nassar
                            self.spinner.hidden = true
                            
                            self.tableView.reloadData()
                        }
                    }else {
                        self.nores.hidden = true
                        
                        self.tableView.reloadData()
                    }
            }
                    self.datas = []
        }
        else if segmentindex == 3{
            usersearcher.hidden = false
            // spinnerblock.hidden=false
            self.datas = []
            let escapedAddress = self.searcher.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url = "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/v2/search.php?scope=description&secid=taB5hzwuWQdLCK%47Z7uj$vR%c2Q+UxEj?x9BS*-term="+escapedAddress!
            
            
            
            
            Alamofire.request(.GET, url)
                .responseJSON { response in
                    
                    if let json = response.result.value {
                        var jsonObj = JSON(json)
                        if let data = jsonObj["search"].arrayValue as [JSON]?{
                            self.datas = data
                            //println(self.datas) http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/search.php?scope=users&term=nassar
                            self.spinner.hidden = true
                            
                            self.tableView.reloadData()
                        }
                    }
                    self.datas = []

            }
        }
        
        return true
    }
    
    
    @IBAction func started(sender: AnyObject) {
        self.searcher.text = "";
        segmentedcontrol.hidden = false
        searchicon.hidden = true
        self.searcher.textAlignment = NSTextAlignment.Left
        
    }
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
    
    
    
    // MARK: UIViewController
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    }
    
    func searchBarShouldBeginEditing( searcher: UISearchBar!){
        segmentedcontrol.hidden = false
        usersearcher.hidden = false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        if (textField == self.searcher) {
            self.searcher.text = "";
            segmentedcontrol.hidden = false
            searchicon.hidden = true
            self.searcher.textAlignment = NSTextAlignment.Left
            usersearcher.hidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.searcher.delegate = self
        usersearcher.hidden = true
        segmentedcontrol.hidden = true
        spinner.hidden = true
        nores.hidden = true
        mapView.delegate = self
        // Initial reachability check
        if reachability!.isReachable() {
            let algorithm : KPGridClusteringAlgorithm = KPGridClusteringAlgorithm()
            
            algorithm.annotationSize = CGSizeMake(25, 50)
            algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase;
            
            clusteringController = KPClusteringController(mapView: self.mapView)
            clusteringController.delegate = self
            let progressHUD = ProgressHUD(text: "Loading...")
            self.view.addSubview(progressHUD)
            
            let delayInSeconds = 0.5
            let popTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(delayInSeconds * Double(NSEC_PER_SEC))) // 1
            dispatch_after(popTime, GlobalMainQueue) { // 2
                
                self.clusteringController.setAnnotations(self.annotations())
                progressHUD.removeFromSuperview()
                
            }
            
            var updateTimer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: "getannot", userInfo: nil, repeats: true)

            
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
        
    }
    
    
    // MARK: Fake annotation set
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goto_video") {
            let secondViewController = segue.destinationViewController as! GlimpView
            let ider = glimperid as String!
            secondViewController.glimpsid = ider
        }
        else if (segue.identifier == "goto_user") {
            let secondViewController = segue.destinationViewController as! UserProfile
            let ider = gid as String!
            let ider2 = gusername as String!
            
            secondViewController.userid = ider
            secondViewController.username = ider2
        }
        else if (segue.identifier == "goto_location") {
            let secondViewController = segue.destinationViewController as! LocationCollectionViewController
            let ider = locID as String!
            let ider2 = locLabel as String!
            
            secondViewController.locid = ider
            secondViewController.loc = ider2
            
        }
        
        
    }
    
    
    
    func annotations() -> [TestAnnotation] {
        var annotations: [TestAnnotation] = []
        let baseURL = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/v2/globe.php?secid=taB5hzwuWQdLCK%47Z7uj$vR%c2Q+UxEj?x9BS*-")
        
        let pointData = try? NSData(contentsOfURL: baseURL!, options: [])
        
        let points = (try! NSJSONSerialization.JSONObjectWithData(pointData!,
            options: [])) as! NSDictionary
        
        
        for point in points["glimps"] as! NSArray {
            let lat = (point as! NSDictionary)["latitude"] as! CLLocationDegrees
            let lon = (point as! NSDictionary)["longitude"] as! CLLocationDegrees
            let gid = String(stringInterpolationSegment: (point as! NSDictionary)["id"]!)
            ///
            let coordinate1 : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
            
            let a1: TestAnnotation = TestAnnotation(coordinate: coordinate1, title: gid)
            
            annotations.append(a1)
            
        }
        
        return annotations
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Usercell", forIndexPath: indexPath) as! Usercell
        
        if segmentindex == 1 {
            usersearcher.hidden = false
            
            let data = datas[indexPath.row]
            
            if let caption = data["name"].string {
                cell.labelCaption.text = caption
                let prefix = String(stringInterpolationSegment: data["categories"][0]["icon"]["prefix"])
                let suffix = String(stringInterpolationSegment: data["categories"][0]["icon"]["suffix"])
                
                let categicon = prefix + "bg_64" + suffix
                
                print(categicon)
                let url = NSURL(string: categicon)
                let imageSize = 50 as CGFloat
                cell.userimage.hnk_cancelSetImage()
                cell.userimage.frame.size.height = imageSize
                cell.userimage.frame.size.width  = imageSize
                cell.userimage.layer.cornerRadius = imageSize / 2.15
                cell.userimage.clipsToBounds = true
                
                cell.userimage.hnk_setImageFromURL(url!)
                
            }
            if let locdesc = data["location"]["address"].string {
                cell.descriptionCap.text = locdesc
            }
            //            var prefix = data["categories"]["icon"][0]["prefix"].string
            //            var suffix = data["categories"]["icon"][0]["suffix"].string
            
            
        }
        else if segmentindex == 2{
            cell.userimage.hnk_cancelSetImage()
            
            let empty: String = " "
            let data = datas[indexPath.row]
            usersearcher.hidden = false
            print(data)
            if let caption = data["username"].string {
                cell.labelCaption.text = caption
                cell.descriptionCap.text = empty
            }
            if let imager = data["profile_pic"].string {
                let url = NSURL(string: imager)
                print(url)
                let imageSize = 50 as CGFloat
                cell.userimage.hnk_cancelSetImage()
                cell.userimage.frame.size.height = imageSize
                cell.userimage.frame.size.width  = imageSize
                cell.userimage.layer.cornerRadius = imageSize / 2.15
                cell.userimage.clipsToBounds = true
                
                cell.userimage.hnk_setImageFromURL(url!)
            }
            
        }
        else if segmentindex == 3{
            cell.userimage.hnk_cancelSetImage()
            let data = datas[indexPath.row]
            usersearcher.hidden = false
            if let caption = data["description"].string {
                cell.labelCaption.text = caption
            }
            if let locdesc = data["loc"].string {
                cell.descriptionCap.text = locdesc
            }
            
            if let imager = data["filename"].string {
                let properurl = "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/thumbnail/"+imager+".png"
                let url = NSURL(string: properurl)
                let imageSize = 50 as CGFloat
                cell.userimage.hnk_cancelSetImage()
                cell.userimage.frame.size.height = imageSize
                cell.userimage.frame.size.width  = imageSize
                cell.userimage.layer.cornerRadius = imageSize / 2.15
                cell.userimage.clipsToBounds = true
                
                cell.userimage.hnk_setImageFromURL(url!)
            }
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        
        if segmentindex == 1 {
            print(datas[row])
            self.locLabel = String(stringInterpolationSegment: datas[row]["name"])
            self.locID = String(stringInterpolationSegment: datas[row]["id"])
            performSegueWithIdentifier("goto_location", sender: self)
        }
        else if segmentindex == 2 {
            print(datas[row])
            self.gid = String(stringInterpolationSegment: datas[row]["id"])
            self.gusername =  String(stringInterpolationSegment: datas[row]["username"])
            performSegueWithIdentifier("goto_user", sender: self)
            
        }
        else if segmentindex == 3 {
            print(datas[row])
            self.glimperid = String(stringInterpolationSegment: datas[row]["id"])
            performSegueWithIdentifier("goto_video", sender: self)
        }
    }
    
    
    
    
func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView : MKAnnotationView?
        
        if annotation is KPAnnotation {
            let a : KPAnnotation = annotation as! KPAnnotation
            
            if a.isCluster() {
                
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("cluster") as MKAnnotationView!
                
                if (annotationView == nil) {
                    annotationView = MKAnnotationView(annotation: a, reuseIdentifier: "cluster")

                    annotationView!.canShowCallout = true
                    
                }
                annotationView!.canShowCallout = false
                
                annotationView!.image =  UIImage(named:"marker1.png")
                
            }
                
            else {
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as MKAnnotationView!

                if (annotationView == nil) {
                    annotationView = MKAnnotationView(annotation: a, reuseIdentifier: "pin")
                }
                annotationView!.canShowCallout = true
                
                annotationView!.image =  UIImage(named:"marker.png")
            }
            
            annotationView!.canShowCallout = false;
        }
        return annotationView;
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        reachability!.startNotifier()
        
        // Initial reachability check
        if reachability!.isReachable() {
            clusteringController.refresh(true)
            
        } else {
            let alertController = UIAlertController(title: "Glimp", message:
                "No Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        }
        
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if view.annotation is KPAnnotation {
            let cluster : KPAnnotation = view.annotation as! KPAnnotation
            
            if cluster.annotations.count > 1 {
                let region = MKCoordinateRegionMakeWithDistance(cluster.coordinate,
                    cluster.radius * 2.5,
                    cluster.radius * 2.5)
                
                mapView.setRegion(region, animated: true)
            }
            if cluster.annotations.count == 1{
                glimperid = view.annotation!.title!
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
