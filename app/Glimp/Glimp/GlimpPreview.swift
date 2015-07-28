

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
    @IBOutlet var Description: AutoCompleteTextField!
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

    ///-----------------------------------------
    
    @IBAction func hidepre(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)

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
    @IBOutlet var tableView: UITableView!
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
        configureTextField()
        handleTextFieldInterfaces()
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
        tap.cancelsTouchesInView = false

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
    
    
    private func configureTextField(){
        Description.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        Description.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        Description.autoCompleteCellHeight = 35.0
        Description.maximumAutoCompleteCount = 20
        Description.hidesWhenSelected = true
        Description.hidesWhenEmpty = true
        Description.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        Description.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        Description.onTextChange = {[weak self] text in
            let prefs = NSUserDefaults.standardUserDefaults()
            
            let name = prefs.stringForKey("USERNAME")
            var usernamep = String(name!)

            if !text.isEmpty {
                
                self!.ticker = count(text) - 1
                println(self!.ticker)
                var idx = advance(text.startIndex,self!.ticker)
                
                if (text[idx] == "@" && self!.flagger == ""){
                    
                    self!.flagger = "@"
                    self!.arr.insert(self!.ticker, atIndex: 0)
                    if self!.connection != nil{
                        self!.connection!.cancel()
                        self!.connection = nil
                    }
                    
                    let urlString = "\(self!.baseURLString)?username=\(usernamep)&query=\(self!.query)"
                    let url = NSURL(string: urlString.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!)
                    if url != nil{
                        let urlRequest = NSURLRequest(URL: url!)
                        println(urlRequest)
                        self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                    }
                    
                }
                else if self!.flagger == "@" {

                    if (text[idx] != " "){
                        
                        self!.arr.insert(self!.ticker, atIndex: 1)
                        if self!.connection != nil{
                            self!.connection!.cancel()
                            self!.connection = nil
                        }
                        if (self!.arr[0]+1 > self!.arr[1]){
                            
                            self!.query = ""
                        } else {
                            self!.query = text[self!.arr[0]+1...self!.arr[1]]
                        }

                        let urlString = "\(self!.baseURLString)?username=\(usernamep)&query=\(self!.query)"
                        let url = NSURL(string: urlString.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!)
                        if url != nil{
                            let urlRequest = NSURLRequest(URL: url!)
                            println(urlRequest)
                            self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                        }
                        
                    } else if (text[idx] == " "){
                        
                        self!.flagger = ""
                    }
                } else if (text[idx] == " "){
                    
                    self!.flagger = ""
                }
                if !(text.contains("@")){
                    println("here")
                    self!.flagger = ""
                    self!.Description.hidesWhenSelected = true
                    self!.Description.hidesWhenEmpty = true
                    
                }
            }
        }
        
        Description.onSelect = {[weak self] text, indexpath in
            self!.Description.hidesWhenSelected = true
            
            var before = self!.Description.text as String
            var ticker = self!.arr[0]
            var dif = (self!.arr[1] - self!.arr[0]+1) - 1
            var texter = String(text) as String
            var end = count(before) - 1
            var fhalf = before[0...ticker]
            var tillafterentry = count(fhalf)+dif
            var ender = count(before)-1
            if (tillafterentry < ender){
                self!.Description.hidesWhenSelected = true
                self!.Description.text = (fhalf + texter + before[tillafterentry...count(before)-1])
            } else {
                self!.Description.hidesWhenSelected = true
                self!.Description.text = (fhalf + texter)
            }
        }
    }
    
    
    //MARK: NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if responseData != nil{
            var error:NSError?
            if let result = NSJSONSerialization.JSONObjectWithData(responseData!, options: nil, error: &error) as? NSDictionary{
                let status = result["status"] as? String
                if status == "OK"{
                    if let predictions = result["predictions"] as? NSArray{
                        println(result["predictions"])
                        
                        var locations = [String]()
                        var autocomp = [String]()
                        
                        for dict in predictions as! [NSDictionary]{
                            locations.append(dict["username"] as! String)
                            autocomp.append(dict["username"] as! String)
                            
                            println(dict["username"])
                        }
                        self.Description.autoCompleteStrings = locations
                        self.Description.autoCompleteStringsrem = autocomp
                        
                    }
                }
                else{
                    self.Description.autoCompleteStrings = nil
                }
            }
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Error: \(error.localizedDescription)")
    }

}



