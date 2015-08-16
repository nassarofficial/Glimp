import UIKit
import CoreLocation
import Alamofire

class ImageCell: UITableViewCell {
    @IBOutlet weak var labelCaption: UILabel!
}
protocol ModalViewControllerDelegate
{
    func sendValue(var value : NSString)
}
extension String
{
    subscript(integerIndex: Int) -> Character {
        let index = advance(startIndex, integerIndex)
        return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = advance(startIndex, integerRange.startIndex)
        let end = advance(startIndex, integerRange.endIndex)
        let range = start..<end
        return self[range]
        
    }
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
    
}


class GlimpPreview: UIViewController,UITableViewDataSource, UITableViewDelegate,PlayerDelegate {
    var ViewControllerVideoPath = ""
    var gllat: Float? = 0.0
    var gllong: Float? = 0.0
    var locLabel: String = "Add Location"
    var locID: String = ""
    let reachability = Reachability.reachabilityForInternetConnection()
    var broadcast_id = "0"
    /// ---------------------------------------
    //@IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    private var responseData:NSMutableData?
    private var selectedPointAnnotation:MKPointAnnotation?
    private var connection:NSURLConnection?
    
    private let baseURLString = "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/friendlist.php"
    var ticker : Int = 0
    var query : String = ""
    var ment : Int = 0
    var i = 0
    var tickerer = 0
    var flagger = ""
    var arr = [Int]()
    var mention = ""
    ///-----------------------------------------
    @IBOutlet var locationer: UITableView!
    
    @IBOutlet var suggester: UITableView!
    @IBOutlet var previewer: UIView!
    
    @IBOutlet var customlocation: UITextField!
    @IBOutlet var Description: UITextView!
    
    @IBAction func custloc(sender: AnyObject) {
        locLabel = customlocation.text
        getlocfs.setTitle(customlocation.text, forState: UIControlState.Normal)
        self.viewofloc.hidden = true

    }
    
    // tbc : foursquare
    var datas: [JSON] = []
    var datasMentions: [JSON] = []

    @IBAction func hidepre(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func getdata(query:String){
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let name = prefs.stringForKey("USERNAME")
        var usernamep = String(name!)

        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/friendlist.php", parameters: ["username": usernamep, "query" : query]).responseJSON { (request, response, json, error) in
            println(response)
            if json != nil {
                var jsonObj = JSON(json!)
                if let data = jsonObj["predictions"].arrayValue as [JSON]?{
                    self.datasMentions = data
                    self.suggester.reloadData()
                }
            }
        }
        
    }

    @IBOutlet weak var uploading: UIVisualEffectView!
    @IBAction func posttoserver(sender: AnyObject) {
        reachability.startNotifier()
        
        // Initial reachability check
        if reachability.isReachable() {
            if Description.text == "Enter Your Description" || Description.text.isEmpty{
                let alertController = UIAlertController(title: "Glimp", message:
                    "Please enter a description", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else if count(Description.text) < 20 {
                let alertController = UIAlertController(title: "Glimp", message:
                    "Please enter more characters (Minimum 20, Maximum 150)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else if (locLabel == "" || locLabel == " " || locLabel == "Add Location") {
            let alertController = UIAlertController(title: "Glimp", message:
                "Please select or enter a different location.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }

            else {
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
                    "username": usernamep,
                    "b_id": broadcast_id
                ]
                
                let manager = AFHTTPRequestOperationManager()
                //let url = "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/upload.php"
                let url = "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/upload-beta.php"
                
                manager.responseSerializer = AFHTTPResponseSerializer()
                manager.POST( url, parameters: params,
                    constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                        println("")
                        var res = data.appendPartWithFileURL(fileURL,name: "fileToUpload", error: nil)
                        println("was file added properly to the body? \(res)")
                    },
                    success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                        println("Yes this was a success")
                        
                        prefs.setInteger(1, forKey: "glimper")
                        prefs.synchronize()
                        self.performSegueWithIdentifier("backtocali", sender: self)
                        
                        
                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                        println("We got an error here.. \(error.localizedDescription)")
                })
                
            } }else {
            let alertController = UIAlertController(title: "Glimp", message:
                "No Connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    @IBOutlet var selectloc: UIButton!
    @IBOutlet weak var viewofpost: UIView!
    @IBOutlet weak var viewofloc: UIView!
    @IBOutlet var getlocfs: UIButton!
    @IBOutlet var getlocid: UIButton!
    
    @IBAction func hidefs(sender: AnyObject) {
        self.viewofloc.hidden = true
    }
    
    func textField(Description: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(Description.text.utf16) + count(string.utf16) - range.length
        return newLength <= 150 // Bool
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
    
    @IBAction func tiyl(sender: AnyObject) {
        customlocation.text = ""
    }
    
    
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
        if let userInfo = sender.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
            var keyboardHeight = CGFloat(keyboardSize?.height ?? 0)
            self.previewer.frame.origin.y -= keyboardHeight

        }

        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
            var keyboardHeight = CGFloat(keyboardSize?.height ?? 0)
            self.previewer.frame.origin.y += keyboardHeight
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.uploading.hidden = true
        ////
        self.suggester.hidden = true
        
        self.viewofloc.hidden = true
        self.viewofpost.hidden = true
        let castlat = NSString(format: "%.2f", gllat!)
        let castlong = NSString(format: "%.2f", gllong!)
        
        locationer.delegate = self
        self.locationer.dataSource = self
        
        suggester.delegate = self
        self.suggester.dataSource = self

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
                    self.locationer.reloadData()
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
        tap.cancelsTouchesInView = false
        if locLabel == ""{
            locLabel = "Add Location"
            getlocfs.setTitle(locLabel, forState: UIControlState.Normal)

        }
    }
    
    
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        if (textField == self.Description) {
            self.Description.text = "";
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
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
    
    
    // tbc : foursquare
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        if tableView == locationer {
            return datas.count
        } else if tableView == suggester {
            return datasMentions.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCell
        if tableView == locationer {
            let data = datas[indexPath.row]
            if let caption = data["name"].string {
                cell.labelCaption.text = caption
            }
        } else if tableView == suggester {
            let data = datasMentions[indexPath.row]
            if let caption = data["username"].string {
                cell.labelCaption.text = caption
            }

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if tableView == locationer {
            let currentCell = self.locationer.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
            let row = indexPath.row
            self.locLabel = datas[row]["name"].string!
            self.locID = datas[row]["id"].string!
            
            getlocfs.setTitle(locLabel, forState: UIControlState.Normal)
            
            self.viewofloc.hidden = true
            // println(self.locID)
            // println(self.locLabel)
        } else if tableView == suggester {
            let currentCell = self.suggester.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
            let row = indexPath.row
            self.mention = datasMentions[row]["username"].string!
            suggester.hidden = true
            var gettext:String = Description!.text
            
            var before = gettext as String
            var ticker = arr[0]
            var tickerend = arr[1]
            var ender = count(before)-1
            var fhalf = before[0...ticker] + self.mention
            if (count(fhalf) < ender){
                suggester.hidden = true
                
            } else {
                suggester.hidden = true
                Description!.text = fhalf
            }
        }
    }
    
    func textViewDidChange(textview: UITextView) { //Handle the text changes here
        var gettext:String = textview.text
        if count(gettext) != 0 {
            suggester.hidden = false
            ticker = count(gettext) - 1
            println(ticker)
            var idx = advance(gettext.startIndex,ticker)
            
            if (gettext[idx] == "@" && flagger == ""){
                arr.insert(ticker, atIndex: 0)
                arr.insert(ticker, atIndex: 1)
                flagger = "@"
                getdata(query)
                
                println("entered mention")
            }
            else if flagger == "@" {
                
                if (gettext[idx] != " "){
                    suggester.hidden = true
                    
                    arr.insert(ticker, atIndex: 1)
                    getdata(query)
                    
                    if (arr[0]+1 > arr[1]){
                        getdata(query)
                        suggester.hidden = false
                        query = ""
                    } else {
                        query = gettext[arr[0]+1...arr[1]]
                        getdata(query)
                        suggester.hidden = true
                    }
                    println(query)
                } else if (gettext[idx] == " "){
                    arr.insert(ticker, atIndex: 1)
                    
                    suggester.hidden = true
                    flagger = ""
                    getdata(query)
                    
                }
            }
            if (gettext[idx] == " "){
                //println(ticker)
                flagger = ""
                suggester.hidden = true
            }
            if (gettext[idx] == " " && flagger == "@"){
                arr.insert(ticker, atIndex: 1)
                suggester.hidden = true
                
            }
            if !(gettext.contains("@")){
                
                flagger = ""
                suggester.hidden = true
            }
            if (flagger == "" && gettext[idx] != "@"){
                suggester.hidden = true
            }
            if (flagger == "@" && gettext[idx] != "@"){
                suggester.hidden = false
                getdata(query)
                
            }
            
        } else {
            suggester.hidden = false
            
        }
    }

    
}