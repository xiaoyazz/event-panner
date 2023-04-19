import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword : UITextField!
    @IBOutlet var btnLogn : UIButton!
    
    @IBAction func passwordEditingDidChange(_ sender: Any) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let canLogin = mainDelegate.userExists(userEmail: tfEmail.text!, userPassword: tfPassword.text!)
        
        if (canLogin) {
            print("Successfully log in")
            mainDelegate.setCurrentEmail(sentEmail: tfEmail.text)
            
            btnLogn.isEnabled = true
        } else {
            btnLogn.isEnabled = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogn.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToLoginViewController(sender: UIStoryboardSegue){
        
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            mainDelegate.setCurrentEmail(sentEmail: nil)
        tfEmail.text=""
           tfPassword.text=""
    }

}
