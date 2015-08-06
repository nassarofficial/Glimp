//
//  UITextField+Extension.swift
//  textViewSample
//
//  Created by Robert Chen on 5/22/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import Alamofire

extension UITextView {
    
    func chopOffNonAlphaNumericCharacters(text:String) -> String {
        var nonAlphaNumericCharacters = NSCharacterSet.alphanumericCharacterSet().invertedSet
        let characterArray = text.componentsSeparatedByCharactersInSet(nonAlphaNumericCharacters)
        return characterArray[0]
    }
    
    /// Call this manually if you want to hash tagify your string.
    func resolveHashTags(){
        
        
        // Iterate over each word.
        // So far each word will look like:
        // - I
        // - visited
        // - #123abc.go!
        // The last word is a hashtag of #123abc
        // Use the following hashtag rules:
        // - Include the hashtag # in the URL
        // - Only include alphanumeric characters.  Special chars and anything after are chopped off.
        // - Hashtags can start with numbers.  But the whole thing can't be a number (#123abc is ok, #123 is not)
        let prefs = NSUserDefaults.standardUserDefaults()
        var datasMentions: [JSON] = []
        
        let name = prefs.stringForKey("USERNAME")
        var usernamep = String(name!)
        var userss = [String]()
        
        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/flist.php", parameters: ["username": usernamep]).responseJSON { (request, response, json, error) in
            println(response)
            if json != nil {
                var jsonObj = JSON(json!)
                if let data = jsonObj["flist"].arrayValue as [JSON]?{
                    datasMentions = data
                    
                    for var i = 0; i < data.count; i++
                    {
                        userss.insert("@"+data[i]["username"].string!, atIndex: i)
                    }
                    let schemeMap = [
                        "#":"hash",
                        "@":"mention"
                    ]
                    
                    // Turn string in to NSString.
                    // NSString gives us some helpful API methods
                    let nsText:NSString = self.text
                    
                    // Separate the string into individual words.
                    // Whitespace is used as the word boundary.
                    // You might see word boundaries at special characters, like before a period.
                    // But we need to be careful to retain the # or @ characters.
                    let words:[NSString] = nsText.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as! [NSString]
                    
                    // Attributed text overrides anything set in the Storyboard.
                    // So remember to set your font, color, and size here.
                    var attrs = [
                        //            NSFontAttributeName : UIFont(name: "Georgia", size: 20.0)!,
                        //            NSForegroundColorAttributeName : UIColor.greenColor(),
                        NSFontAttributeName : UIFont.systemFontOfSize(17.0)
                    ]
                    
                    // Use an Attributed String to hold the text and fonts from above.
                    // We'll also append to this object some hashtag URLs for specific word ranges.
                    var attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)

                    for word in words {
                        
                        var scheme:String? = nil
                        
                        if word.hasPrefix("#") {
                            scheme = schemeMap["#"]
                        } else if word.hasPrefix("@") && contains(userss,word as String) {
                            scheme = schemeMap["@"]
                        }
                        
                        // found a word that is prepended by a hashtag
                        if let scheme = scheme {
                            
                            // convert the word from NSString to String
                            // this allows us to call "dropFirst" to remove the hashtag
                            var stringifiedWord:String = word as String
                            
                            // example: #123abc.go!
                            
                            // drop the hashtag
                            // example becomes: 123abc.go!
                            stringifiedWord = dropFirst(stringifiedWord)
                            
                            // Chop off special characters and anything after them.
                            // example becomes: 123abc
                            stringifiedWord = self.chopOffNonAlphaNumericCharacters(stringifiedWord)
                            
                            if let stringIsNumeric = stringifiedWord.toInt() {
                                // don't convert to hashtag if the entire string is numeric.
                                // example: 123abc is a hashtag
                                // example: 123 is not
                            } else if stringifiedWord.isEmpty {
                                // do nothing.
                                // the word was just the hashtag by itself.
                            } else {
                                // set a link for when the user clicks on this word.
                                var matchRange:NSRange = nsText.rangeOfString(stringifiedWord as String)
                                // Remember, we chopped off the hash tag, so:
                                // 1.) shift this left by one character.  example becomes:  #123ab
                                matchRange.location--
                                // 2.) and lengthen the range by one character too.  example becomes:  #123abc
                                matchRange.length++
                                // URL syntax is http://123abc
                                
                                // Replace custom scheme with something like hash://123abc
                                // URLs actually don't need the forward slashes, so it becomes hash:123abc
                                // Custom scheme for @mentions looks like mention:123abc
                                // As with any URL, the string will have a blue color and is clickable
                                attrString.addAttribute(NSLinkAttributeName, value: "\(scheme):\(stringifiedWord)", range: matchRange)
                            }
                        }
                        
                    }
                    self.attributedText = attrString


                }
            }
        }

        // Use textView.attributedText instead of textView.text
    }
    
}
