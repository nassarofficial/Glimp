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

class Hashtag: UIViewController {

    @IBOutlet weak var navbar: UINavigationBar!
    var datas: [JSON] = []
    var datar: [JSON] = []

    @IBOutlet var collectionView: UICollectionView!
    var loc: String = ""
    var glimperid: String = ""
    @IBAction func unwindToSegueprod (segue : UIStoryboardSegue) {}
    @IBOutlet weak var vidcolindicator: UIActivityIndicatorView!
    @IBOutlet weak var noglimps: UILabel!

    @IBOutlet var hashtagger: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden=false;
        noglimps.hidden = true
        vidcolindicator.hidden = false

        // Do any additional setup after loading the view, typically from a nib.
        println("location: "+loc)
        //vidcolindicator.hidden = false
        hashtagger.text = "#"+loc
            Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/hashtag.php", parameters: [ "hashtag": loc]).responseJSON { (request, response, json, error) in
                if json != nil {
                    var jsonObj = JSON(json!)
                    if let data = jsonObj["hashtag"].arrayValue as [JSON]?{
                        self.datas = data
                        println(self.datas)
                        self.collectionView.reloadData()
                        self.vidcolindicator.hidden = true
                    }
                }
                else {
                    self.noglimps.hidden = false
                }
                println(response)
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

