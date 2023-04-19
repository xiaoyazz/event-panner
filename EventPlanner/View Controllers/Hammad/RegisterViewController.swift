import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var tfName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitInfo(sender : Any) {
        let person : User = User.init()
        
        person.initWithData(theRow: 0, theName: tfName.text!, theEmail: tfEmail.text!, thePassword: tfPassword.text!)
         
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
         
        let returnCode : Bool = mainDelegate.insertIntoUserDatabase(person: person)
         
        var returnMSG : String = "User Added"
         
        if returnCode == false {
            returnMSG = "User Could not be Created"
        }
        
        let alert = UIAlertController(title: "Thank you", message: returnMSG, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
