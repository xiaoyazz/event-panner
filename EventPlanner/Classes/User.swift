import UIKit

class User: NSObject {
    var id : Int?
    var name : String?
    var email : String?
    var password : String?
        
    func initWithData(theRow i:Int, theName n:String, theEmail e:String, thePassword p:String) {
        id = i
        name = n
        email = e
        password = p
    }
}
