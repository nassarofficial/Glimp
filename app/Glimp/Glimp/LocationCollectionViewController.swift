//
//  LocationCollectionViewController.swift
//  Glimp
//
//  Created by Ahmed Nassar on 5/31/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LocationCollectionViewController: UIViewController {

    @IBOutlet weak var navbar: UINavigationBar!
    var datas: [JSON] = []
    var datar: [JSON] = []

    @IBOutlet var collectionView: UICollectionView!
    var locid: String = ""
    var loc: String = ""
    var glimperid: String = ""
    @IBAction func unwindToSegueprod (segue : UIStoryboardSegue) {}

    @IBOutlet weak var locationname: UILabel!
    @IBOutlet weak var locdescription: UILabel!
    
    @IBOutlet weak var noglimps: UILabel!
    @IBOutlet weak var headindicator: UIActivityIndicatorView!
    @IBOutlet weak var vidcolindicator: UIActivityIndicatorView!
    @IBOutlet weak var locphoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("locationid: "+locid)
        println("location: "+loc)
        vidcolindicator.hidden = false
        headindicator.hidden = false
        
        if locid == "" {
            locationname.text = loc
            locdescription.text = ""
            headindicator.hidden = true
            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/loc.php", parameters: [ "locid": loc]).responseJSON { (request, response, json, error) in
                if json != nil {
                    var jsonObj = JSON(json!)
                    if let data = jsonObj["loc"].arrayValue as [JSON]?{
                        self.datas = data
                        //println(self.datas)
                        self.collectionView.reloadData()
                        self.vidcolindicator.hidden = true
                        self.noglimps.hidden = true
                    }
                }
                println(response)
            }
            
        } else {
            
            Alamofire.request(.GET, "https://api.foursquare.com/v2/venues/\(locid)?client_id=DPUDNKBQKC12FJ0KBRLVU5BG4JREZV1YAIVRXIULPLFZHMAL&client_secret=PA0I5FS3JWPDMOL0H5XLQNDJYBJPGNOEP4QX1ML23YOFGZ3G&v=20140806").responseJSON { (request, response, json, error) in
                if json != nil {
                    var json = JSON(json!)
                    self.locationname.text = json["response"]["venue"]["name"].string
                    
                    
                    var a1 = json["response"]["venue"]["location"]["city"].string
                    var a2 = json["response"]["venue"]["location"]["country"].string
                    
                    if a1 == nil {
                        self.locdescription.text = a2!

                    } else if a2 == nil {
                        self.locdescription.text = a1!

                    } else {
                    self.locdescription.text = a1! + ", " + a2!
                    }
                    
                    var prefix = json["response"]["venue"]["bestPhoto"]["prefix"].string
                    var ims = "400x300"
                    var suffix = json["response"]["venue"]["bestPhoto"]["suffix"].string

                    
                    if prefix == nil {
                        var properurl = ""
                    } else
                    {
                        var properurl = prefix! + ims + suffix!
                        let url = NSURL(string: properurl)
                        self.locphoto.clipsToBounds = true
                        self.locphoto.hnk_setImageFromURL(url!)

                    }
                    self.noglimps.hidden = true
                    self.headindicator.hidden = true
                }
            }
            
            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/locid.php", parameters: [ "locid": locid]).responseJSON { (request, response, json, error) in
                var jsonObj = JSON(json!)
                if json != nil {
                    if let data = jsonObj["loc"].arrayValue as [JSON]?{
                        self.datas = data
                        //println(self.datas)
                        self.collectionView.reloadData()
                        self.vidcolindicator.hidden = true
                        println(self.datas)
                        if jsonObj["loc"].stringValue == "nothing"{
                            println("triggered")
                            self.noglimps.hidden = false
                        }
                    }
                }

            }
            
            
        }

    }
    
    override func viewWillAppear(animated: Bool) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goto_video") {
            let secondViewController = segue.destinationViewController as! GlimpView
            let ider = glimperid as String!
            secondViewController.glimpsid = ider
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let row = indexPath.row
        glimperid = self.datas[indexPath.row]["id"].stringValue
        println(glimperid)
        self.performSegueWithIdentifier("goto_video", sender: self)

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return datas.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.data = self.datas[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
}

