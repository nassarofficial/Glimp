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
        print("location: "+loc)
        //vidcolindicator.hidden = false
        hashtagger.text = "#"+loc
        
        Alamofire.request(.POST, "http://glimpglobe.com/v2/hashtag.php", parameters: [ "hashtag": loc, "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"])
            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let json = response.result.value {
                    var jsonObj = JSON(json)
                    if let data = jsonObj["hashtag"].arrayValue as [JSON]?{
                        self.datas = data
                        //print(self.datas)
                        self.collectionView.reloadData()
                        self.vidcolindicator.hidden = true
                    } else {
                        self.noglimps.hidden = false
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
        glimperid = self.datas[indexPath.row]["id"].stringValue
        print(glimperid)
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

