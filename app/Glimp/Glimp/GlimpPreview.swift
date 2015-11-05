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
        let index = startIndex.advancedBy(integerIndex)
        return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = startIndex.advancedBy(integerRange.startIndex)
        let end = startIndex.advancedBy(integerRange.endIndex)
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
    
    private let baseURLString = "http://glimpglobe.com/friendlist.php"
    var ticker : Int = 0
    var query : String = ""
    var ment : Int = 0
    var i = 0
    var tickerer = 0
    var flagger = ""
    var arr = [Int]()
    var mention = ""
    var logger = 1
    ///-----------------------------------------
    @IBOutlet var locationer: UITableView!
    
    @IBOutlet var suggester: UITableView!
    @IBOutlet var previewer: UIView!
    
    @IBOutlet var customlocation: UITextField!
    @IBOutlet var Description: UITextView!
    
    @IBAction func custloc(sender: AnyObject) {
        locLabel = customlocation.text!
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
        let usernamep = String(name!)

        
        Alamofire.request(.POST, "http://glimpglobe.com/v2/friendlist.php", parameters: ["username": usernamep, "query" : query, "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"])
            .responseJSON { response in
                if let json = response.result.value {
                    var jsonObj = JSON(json)
                    if let data = jsonObj["predictions"].arrayValue as [JSON]?{
                        self.datasMentions = data
                        self.suggester.reloadData()
                    }
                }
        }
        
        
    }

    @IBOutlet weak var uploading: UIVisualEffectView!
    @IBAction func posttoserver(sender: AnyObject) {
        reachability!.startNotifier()
        
        // Initial reachability check
        if reachability!.isReachable() {
            if Description.text == "Enter Your Description" || Description.text.isEmpty{
                let alertController = UIAlertController(title: "Glimp", message:
                    "Please enter a description", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else if Description.text.characters.count < 20 {
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
                let usernamep = String(name!)
                
                
                let fileURL = NSURL.fileURLWithPath(self.ViewControllerVideoPath)
                print(fileURL)
//                let params = [
//                    "latitude": gllat!,
//                    "longitude": gllong!,
//                    "loc" : locLabel,
//                    "locid": locID,
//                    "desc" : Description.text,
//                    "username": usernamep,
//                    "b_id": broadcast_id,
//                    "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"
//                ]
                let latter: String = gllat!.description
                let longer: String = gllong!.description
                print(latter)
                print(longer)

//                let manager = AFHTTPRequestOperationManager()
//                //let url = "http://glimpglobe.com/upload.php"
//                let url = "http://glimpglobe.com/uploader.php"
//                
//                manager.responseSerializer = AFHTTPResponseSerializer()
//                manager.POST( url, parameters: params,
//                    constructingBodyWithBlock: { (data: AFMultipartFormData!) -> Void in
//                        print("")
//                        //problem
//                        let res = trdata.appendPartWithFileURL(fileURL,name: "fileToUpload")
//                        print("was file added properly to the body? \(res)")
//                    },
//                    success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
//                        print("Yes this was a success")
//                        
//                        prefs.setInteger(1, forKey: "glimper")
//                        prefs.synchronize()
//                        self.performSegueWithIdentifier("backtocali", sender: self)
//                        
//                        
//                    },
//                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
//                        print("We got an error here.. \(error.localizedDescription)")
//                })
                
                Alamofire.upload(
                    .POST,
                    "http://glimpglobe.com/uploader.php",
                    multipartFormData: { multipartFormData in
                        multipartFormData.appendBodyPart(fileURL: fileURL, name: "fileToUpload")
                        multipartFormData.appendBodyPart(data:latter.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"latitude")
                        multipartFormData.appendBodyPart(data:longer.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"longitude")
                        multipartFormData.appendBodyPart(data:self.locLabel.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"loc")
                        multipartFormData.appendBodyPart(data:self.locID.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"locid")

                        multipartFormData.appendBodyPart(data:self.Description.text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"desc")
                        multipartFormData.appendBodyPart(data:usernamep.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"username")
                        multipartFormData.appendBodyPart(data:self.broadcast_id.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"b_id")
                        multipartFormData.appendBodyPart(data:"yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"secid")

                    },
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseJSON { response in
                                debugPrint(response)
                                                        prefs.setInteger(1, forKey: "glimper")
                                                        prefs.synchronize()
                                                        self.performSegueWithIdentifier("backtocali", sender: self)

                            }
                        case .Failure( _):
                            let alertController = UIAlertController(title: "Glimp", message:
                                "Upload Failed", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                )

                
                
                
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
        let newLength = Description.text!.utf16.count + string.utf16.count - range.length
        return newLength <= 150 // Bool
    }
    
    @IBAction func getlocfs(sender: AnyObject) {
        reachability!.startNotifier()
        
        // Initial reachability check
        if reachability!.isReachable() {
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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: view lifecycle
    
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
            let keyboardHeight = CGFloat(keyboardSize?.height ?? 0)
            self.previewer.frame.origin.y -= keyboardHeight

        }

        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
            let keyboardHeight = CGFloat(keyboardSize?.height ?? 0)
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
        print(ViewControllerVideoPath)
        Alamofire.request(.GET, "https://api.foursquare.com/v2/venues/search?ll=\(castlat),\(castlong)&client_id=DPUDNKBQKC12FJ0KBRLVU5BG4JREZV1YAIVRXIULPLFZHMAL&client_secret=PA0I5FS3JWPDMOL0H5XLQNDJYBJPGNOEP4QX1ML23YOFGZ3G&v=20140806")
            .responseJSON { response in
                if let json = response.result.value {
                    var jsonObj = JSON(json)
                    if let data = jsonObj["response"]["venues"].arrayValue as [JSON]?{
                        self.datas = data
                        //println(self.datas)
                        self.locationer.reloadData()
                    }
                }
        }

        
        self.tabBarController?.tabBar.hidden = true
        
        self.view.autoresizingMask = ([UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight])
        
        self.player = Player()
        self.player.delegate = self
        self.player.view.frame = self.previewer.bounds
        
        self.addChildViewController(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMoveToParentViewController(self)
        
        self.player.path = self.ViewControllerVideoPath
        self.view.sendSubviewToBack(self.player.view)
        self.player.playbackLoops = true
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizer:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        // tbc : foursquare
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
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
    func textViewDidBeginEditing(textView: UITextView) {
        if logger == 1 {
            Description.text = ""
            logger = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
    }

    override func viewWillAppear(animated: Bool) {
        getlocfs.setTitle(locLabel, forState: UIControlState.Normal)
        
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
    
//    func textViewDidBeginEditing(Description: UITextView)
//    {
//    }
//    
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
            let row = indexPath.row
            self.locLabel = datas[row]["name"].string!
            self.locID = datas[row]["id"].string!
            
            getlocfs.setTitle(locLabel, forState: UIControlState.Normal)
            
            self.viewofloc.hidden = true
            // println(self.locID)
            // println(self.locLabel)
        } else if tableView == suggester {
            let row = indexPath.row
            self.mention = datasMentions[row]["username"].string!
            suggester.hidden = true
            let gettext:String = Description!.text
            
            let before = gettext as String
            let ticker = arr[0]
            let ender = before.characters.count-1
            let fhalf = before[0...ticker] + self.mention
            if (fhalf.characters.count < ender){
                suggester.hidden = true
                
            } else {
                suggester.hidden = true
                Description!.text = fhalf
            }
        }
    }
    
    func textViewDidChange(textview: UITextView) { //Handle the text changes here
        let gettext:String = textview.text
        if gettext.characters.count != 0 {
            suggester.hidden = false
            ticker = gettext.characters.count - 1
            print(ticker)
            let idx = gettext.startIndex.advancedBy(ticker)
            
            if (gettext[idx] == "@" && flagger == ""){
                arr.insert(ticker, atIndex: 0)
                arr.insert(ticker, atIndex: 1)
                flagger = "@"
                getdata(query)
                
                print("entered mention")
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
                    print(query)
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