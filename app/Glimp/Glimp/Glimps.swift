import UIKit
@objc public protocol ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, representation: AnyObject)
}

class glimps: NSObject, ResponseObjectSerializable {
    let id: Int
    var user_id: Int?
    
    var latitude: Float?
    var longitude: Float?

    let filename: String
    var loc: String?
    var locid: String?

    var likes: Int?
    var views: Int?
    var time: String?

    var tplus: Int?
    


    init(id: Int, url: String) {
        self.id = id
        self.filename = url
    }
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKeyPath("glimps.id") as! Int
        self.user_id = representation.valueForKeyPath("glimps.user_id") as? Int
        self.latitude = representation.valueForKeyPath("glimps.latitude") as? Float
        self.longitude = representation.valueForKeyPath("glimps.longitude") as? Float

        self.filename = representation.valueForKeyPath("glimps.filename") as! String

        self.loc = representation.valueForKeyPath("glimps.loc") as? String

        self.locid = representation.valueForKeyPath("glimps.locid") as? String

        self.likes = representation.valueForKeyPath("glimps.likes") as? Int
        self.views = representation.valueForKeyPath("glimps.views") as? Int
        self.time = representation.valueForKeyPath("glimps.time") as? String
        self.tplus = representation.valueForKeyPath("glimps.tplus") as? Int
    }
    
    // Used by NSMutableOrderedSet to maintain the order
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! glimps).id == self.id
    }
    
    // Used by NSMutableOrderedSet to check for uniqueness when added to a set
    override var hash: Int {
        return (self as glimps).id
    }
}
