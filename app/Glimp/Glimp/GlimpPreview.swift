

import UIKit
import CoreLocation
import Alamofire

class ImageCell: UITableViewCell {
    @IBOutlet weak var labelCaption: UILabel!
}

class GlimpPreview: UIViewController,UITableViewDataSource, UITableViewDelegate,PlayerDelegate {
    var ViewControllerVideoPath = ""
    var gllat: Float? = 0.0
    var gllong: Float? = 0.0
    var locLabel: String = "Add Location"
    var locID: String = ""
    let reachability = Reachability.reachabilityForInternetConnection()

    @IBAction func hidepre(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)

    }
    @IBOutlet weak var uploading: UIVisualEffectView!
    @IBAction func posttoserver(sender: AnyObject) {
        reachability.startNotifier()
        
        // Initial reachability check
        if reachability.isReachable() {
            self.uploading.hidden = false
            
            let prefs = NSUserDefaults.standardUserDefaults()
            let name = prefs.stringForKey("USERNAME")
            var usernamep = String(name!)
            // now lets get the directory contents (including folders)
            var progress: NSProgress?
            
            var fileURL = NSURL.fileURLWithPath(self.ViewControllerVideoPath)!
            
            var params = [
                "latitude": gllat!,
                "longitude": gllong!,
                "loc" : locLabel,
                "locid": locID,
                "desc" : Description.text,
                "username": usernamep
            ]
            
            let manager = AFHTTPRequestOperationManager()
            let url = "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/upload.php"
            //let url = "http://localhost/upload.php"

            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.POST( url, parameters: params,
                constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                    println("")
                    var res = data.appendPartWithFileURL(fileURL,name: "fileToUpload", error: nil)
                    println("was file added properly to the body? \(res)")
                },
                success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success")
                    self.dismissViewControllerAnimated(true, completion: nil)


                },
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription)")
            })
            
        } else {
            let alertController = UIAlertController(title: "Glimp", message:
                "No Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)

        }

    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var Description: UITextView!
    @IBOutlet weak var viewofpost: UIView!
    @IBOutlet weak var viewofloc: UIView!
    @IBOutlet var getlocfs: UIButton!
    @IBOutlet var getlocid: UIButton!
    
    @IBAction func hidefs(sender: AnyObject) {
        self.viewofloc.hidden = true
    }
    
    @IBAction func getlocfs(sender: AnyObject) {
        reachability.startNotifier()
        
        // Initial reachability check
        if reachability.isReachable() {
            self.viewofloc.hidden = false
        } else {
            let alertController = UIAlertController(title: "Glimp", message:
                "No Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)

        }
        
    }
    
    @IBAction func postbutton(sender: AnyObject) {
        self.viewofpost.hidden = false
        
    }
    
    @IBOutlet var previewer: UIView!
    
    // tbc : foursquare
    var datas: [JSON] = []
    
    
    private var player: Player!
    
    // MARK: object lifecycle
    
    //    override init() {
    //        super.init()
    //    }
    //
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    // MARK: view lifecycle
    
    
    func keyboardWillShow(sender: NSNotification) {
        self.previewer.frame.origin.y -= 217
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.previewer.frame.origin.y += 217
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.uploading.hidden = true

        self.viewofloc.hidden = true
        self.viewofpost.hidden = true
        let castlat = NSString(format: "%.2f", gllat!)
        let castlong = NSString(format: "%.2f", gllong!)
        tableView.delegate = self
        self.tableView.dataSource = self
        
        /////
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        ////
              
                Alamofire.request(.GET, "https://api.foursquare.com/v2/venues/search?ll=\(castlat),\(castlong)&client_id=DPUDNKBQKC12FJ0KBRLVU5BG4JREZV1YAIVRXIULPLFZHMAL&client_secret=PA0I5FS3JWPDMOL0H5XLQNDJYBJPGNOEP4QX1ML23YOFGZ3G&v=20140806").responseJSON { (request, response, json, error) in
                    if json != nil {
                        var jsonObj = JSON(json!)
                        if let data = jsonObj["response"]["venues"].arrayValue as [JSON]?{
                            self.datas = data
                            //println(self.datas)
                            self.tableView.reloadData()
                        }
                    }
                }
        
        self.tabBarController?.tabBar.hidden = true
        
        self.view.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight)
        
        self.player = Player()
        self.player.delegate = self
        self.player.view.frame = self.previewer.bounds
        
        self.addChildViewController(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMoveToParentViewController(self)
        
        self.player.path = self.ViewControllerVideoPath;
        self.view.sendSubviewToBack(self.player.view)
        self.player.playbackLoops = true
        
        var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizer:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        // tbc : foursquare
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        getlocfs.setTitle(locLabel, forState: UIControlState.Normal)
        
        let castlat = NSString(format: "%.2f", gllat!)
        let castlong = NSString(format: "%.2f", gllong!)
        
        
        UIApplication.sharedApplication().statusBarHidden=true;
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.viewofpost.hidden = true
        
        self.player.playFromBeginning()
    }
    
    
    // MARK: UIGestureRecognizer
    
    func handleTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.Stopped.rawValue:
            self.player.playFromBeginning()
        case PlaybackState.Paused.rawValue:
            self.player.playFromCurrentTime()
        case PlaybackState.Playing.rawValue:
            self.player.pause()
        case PlaybackState.Failed.rawValue:
            self.player.pause()
        default:
            self.player.pause()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: PlayerDelegate
    
    func playerReady(player: Player) {
    }
    
    func playerPlaybackStateDidChange(player: Player) {
    }
    
    func playerBufferingStateDidChange(player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
    }
    
    func playerPlaybackDidEnd(player: Player) {
    }
    
    func textViewShouldBeginEditing(Description: UITextView) -> Bool
    {
        return true
    }
    
    func textViewShouldEndEditing(Description: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(Description: UITextView)
    {
    }
    
    func textViewDidEndEditing(Description: UITextView)
    {
    }
    
    func textViewDidChange(Description: UITextView)
    {
    }
    
    // tbc : foursquare
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "goto_globe1" {
            
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
        
        let data = datas[indexPath.row]
        if let caption = data["name"].string {
            cell.labelCaption.text = caption
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let currentCell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
        let row = indexPath.row
        self.locLabel = datas[row]["name"].string!
        self.locID = datas[row]["id"].string!
        
        getlocfs.setTitle(locLabel, forState: UIControlState.Normal)
        
        self.viewofloc.hidden = true
       // println(self.locID)
       // println(self.locLabel)
    }
    
    
    
}



