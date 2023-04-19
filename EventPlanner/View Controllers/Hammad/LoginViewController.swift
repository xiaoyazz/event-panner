import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfPassword : UITextField!
    @IBOutlet var btnLogn : UIButton!
    
    @IBAction func passwordEditingDidChange(_ sender: Any) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let canLogin = mainDelegate.userExists(userEmail: tfEmail.text!, userPassword: tfPassword.text!)
        
        if (canLogin) {
            print("can log in")
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
