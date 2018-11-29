//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import FirebaseAuth
import SVProgressHUD

class LogInViewController: UIViewController, UITextFieldDelegate {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {            
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            passwordTextfield.resignFirstResponder()
        }
        
        return true
    }
   
    @IBAction func logInPressed(_ sender: AnyObject) {
        let emailTextLength = emailTextfield.text?.trim().count
        let passwordTextLength = passwordTextfield.text?.trim().count
        
        if emailTextLength! == 0 {
            showAlert(title: "Empty email", message: "Email cant be empty to perform login.")
            return
        } else if passwordTextLength == 0{
            showAlert(title: "Empty password", message: "Password cant be empty to perform login")
            return
        }
        
        //show loading
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!)
        { (result, error) in
            
            if error != nil {
                SVProgressHUD.dismiss()
                
                print(error.debugDescription)
                
                if error.debugDescription.contains("17011"){
                    self.showAlert(title: "Login Error", message: "This email is not registered yet, please register with this email first then, you can perform login next time")
                } else if error.debugDescription.contains("17009"){
                    self.showAlert(title: "Login Error", message: "The password is invalid, please write the proper password before continue")
                } else{
                    self.showAlert(title: "Login Error", message: "Make sure you're connected to internet before perform login operation.")
                }
            } else{
                //success
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "understand", style: .default){
            UIAlertAction in
            alert.dismiss(animated: true, completion: nil)
        })
        
        present(alert, animated: true)
    }

    
}  
