//
//  CollectionViewCell.swift
//  RevivalxCollectionView
//
//  Created by Mohammad Nurdin bin Norazan on 2/25/15.
//  Copyright (c) 2015 Nurdin Norazan Services. All rights reserved.
//

import UIKit
import Haneke

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView:UIImageView!
    
    var data:JSON?{
        didSet{
            self.setupData()
        }
    }
    
    func setupData(){
        
        if let urlString = self.data?["filename"]{
            let url = NSURL(string: "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/thumbnail/"+urlString.stringValue+".png")
            self.imageView.hnk_setImageFromURL(url!)
            println(url)
        }
        
    }

}
