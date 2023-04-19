import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func submitInfo(sender : Any) {
        let person : User = User.init()
        
        person.initWithData(theRow: 0, theName: tfName.text!, theEmail: tfEmail.text!, thePassword: tfPassword.text!)
         
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
         
        let returnCode : Bool = mainDelegate.insertIntoUserDatabase(person: person)
         
        var returnMSG : String = "Account has been registered."
         
        if returnCode == false {
            returnMSG = " but unfortunally sign up failed."
        }
        
        let alert = UIAlertController(title: "Thank you ", message: returnMSG, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }


}
