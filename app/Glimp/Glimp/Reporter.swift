//
//  Reporter.swift
//  Glimp
//
//  Created by Ahmed Nassar on 8/4/15.
//  Copyright (c) 2015 Ahmed Nassar. All rights reserved.
//

import UIKit
import Alamofire

class Reporter: UIViewController {
    var datas: [JSON] = []

    var glimpid = ""
    var reporttype = ""
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var buttonrep: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var textrep: UILabel!
    
    @IBAction func reportnow(sender: AnyObject) {
        spinner.hidden = false
        self.buttonrep.enabled = false
        
        Alamofire.request(.POST, "http://glimpglobe.com/v2/report.php", parameters: ["glimpid": self.glimpid, "reportid":self.reporttype,"description":textView.text, "secid": "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"])
            .responseJSON { response in
                
                    self.spinner.hidden = true
                    self.textrep.hidden = false
        }
        textView.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden=false
        spinner.hidden = true
        self.textrep.hidden = true

        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard() {
        textView.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.
    }
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        textView.resignFirstResponder()   //FirstResponder's must be resigned for hiding keyboard.

        self.view.endEditing(true);
        return false;
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
