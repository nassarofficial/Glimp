//
//  Follow.swift
//  Glimp
//
//  Created by Ahmed Nassar on 10/6/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Alamofire

class Follow: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var datas: [JSON] = []
    var type: Int = 0
    var usernamep:String = ""
    @IBAction func unwindToSegueG (segue : UIStoryboardSegue) {
    }

    @IBOutlet var followbar: UINavigationBar!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        println(type)
        if (type==1){
            followbar.topItem?.title = "Followers"
        }else if (type==2){
            followbar.topItem?.title = "Following"

        }
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let name = prefs.stringForKey("USERNAME")
        var usernamep = String(name!)
        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/flister.php", parameters: ["username": usernamep, "type" : type]).responseJSON { (request, response, json, error) in
            if json != nil {
                println(request)
                println(response)

                var jsonObj = JSON(json!)
                if let data = jsonObj["list"].arrayValue as [JSON]?{
                    self.datas = data
                    self.tableView.reloadData()
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return datas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell
        
            let data = datas[indexPath.row]
            if let captionLabel = cell.viewWithTag(100) as? UILabel {
                if let caption = data["username"].string{
                    
                    captionLabel.text = caption
                    
                }
            }
            if let imageView = cell.viewWithTag(101) as? UIImageView {
                if let urlString = data["profile_pic"].string{
                    let url = NSURL(string: urlString)
                    println(url)
                    let imageSize = 65 as CGFloat
                    imageView.frame.size.height = imageSize
                    imageView.frame.size.width  = imageSize
                    imageView.layer.cornerRadius = imageSize / 2.0
                    imageView.clipsToBounds = true
                    
                    imageView.hnk_setImageFromURL(url!)
                }
            }
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println(segue.identifier)
        if (segue.identifier == "goto_profile") {
            let secondViewController = segue.destinationViewController as! UserProfile
            let ider2 = usernamep as String!
            secondViewController.username = ider2
        }
        
    }

    
    func textField(Description: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(Description.text.utf16) + count(string.utf16) - range.length
        return newLength <= 150 // Bool
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
            let currentCell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
            let row = indexPath.row
            self.usernamep = datas[row]["username"].string!
            self.performSegueWithIdentifier("goto_profile", sender: self)

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
