//
//  imagePicker.swift
//  Glimp
//
//  Created by Ahmed Nassar on 6/15/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Haneke
import Alamofire

class ImagePicker: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate{
    @IBOutlet weak var btnClickMe: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var profilepic: String = ""
    var booler: String = "0"
    
    @IBOutlet weak var setp: UIButton!
    @IBAction func setpp(sender: AnyObject) {
//        let progressHUD = ProgressHUD(text: "Uploading...")
//        self.view.addSubview(progressHUD)
        let progressHUD = ProgressHUD(text: "Uploading...")
        self.view.addSubview(progressHUD)

            let prefs = NSUserDefaults.standardUserDefaults()
            let name = prefs.stringForKey("USERNAME")
            let usernamep = String(name!)
            // now lets get the directory contents (including folders)
            
            let imageData: NSMutableData = NSMutableData(data: UIImageJPEGRepresentation(imageView.image!, 0.5)!);
            
            let params = [
                "username": usernamep,
                "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"
            ]
            
            let manager = AFHTTPRequestOperationManager()
            let url = "http://glimpglobe.com/v2/picupload.php"
            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.POST( url, parameters: params,
                constructingBodyWithBlock: { (data: AFMultipartFormData!) in
                    print("", terminator: "")
                    let res: Void = data.appendPartWithFileData(imageData, name: "fileToUpload", fileName: "randomimagename.jpg", mimeType: "image/jpeg")
                    print("was file added properly to the body? \(res)", terminator: "")
                    progressHUD.removeFromSuperview()

                },
                success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    print("Yes this was a success", terminator: "")
                    progressHUD.removeFromSuperview()
                },
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    print("We got an error here.. \(error.localizedDescription)", terminator: "")
                    progressHUD.removeFromSuperview()
            })
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let progressHUD = ProgressHUD(text: "Loading...")
        self.view.addSubview(progressHUD)

        let prefs = NSUserDefaults.standardUserDefaults()
        let name = prefs.stringForKey("USERNAME")
        
        
        Alamofire.request(.POST, "http://glimpglobe.com/v2/profilepic.php", parameters: ["username": name!, "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"])
            .responseJSON { response in
                if let points = response.result.value {
                    
                    for point in points["profilepic"] as! NSArray {
                        self.profilepic = String(stringInterpolationSegment: (point as! NSDictionary)["profile_pic"]!)
                    }
                    if self.profilepic == "http://glimpglobe.com/profilepic.jpeg"{
                        self.imageView.image = UIImage(named: "add_photo-1");
                        progressHUD.removeFromSuperview()
                    }
                    else {
                        let url = NSURL(string: self.profilepic)
                        print(url, terminator: "")
                        self.imageView.hnk_setImageFromURL(url!)
                        progressHUD.removeFromSuperview()
                        
                    }
                    if self.booler == "1" {
                        self.setp.enabled = true
                    }
                    else{
                        self.setp.enabled = false
                    }
                    self.picker!.delegate=self

                }
        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnImagePickerClicked(sender: AnyObject)
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        self.booler = "1"
        setp.enabled = true

        picker .dismissViewControllerAnimated(true, completion: nil)
        imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

