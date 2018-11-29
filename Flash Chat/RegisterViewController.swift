//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import FirebaseAuth
import SVProgressHUD


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //Pre-linked IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        if (emailTextfield.text?.trim().isEmpty)! {
            showDialog(title: "Empty Email", message: "To perform register please fill the email form")
            return
        } else if((passwordTextfield.text?.trim().isEmpty)!){
            showDialog(title: "Empty Password", message: "To perform register please fill the password form")
            return
        }
        
        //show the progress
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!){
            (authResult, error) in
            
            if error != nil{
                SVProgressHUD.dismiss()
                
                if error.debugDescription.contains("17007") {
                    self.showDialog(title: "Registration Error", message: "The email and password already used by another account.")
                } else if error.debugDescription.contains("17008") {
                    self.showDialog(title: "Registration Error", message: "The email address is badly formatted, please use proper email address like @gmail and @yahoo.")
                } else if error.debugDescription.contains("17026"){
                    self.showDialog(title: "Registration Error", message: "The password must be 6 characters long or more.")
                }
            } else{
                SVProgressHUD.dismiss()
                self.showDialog(title: "Registration Success", message: "Thankyou for using our apps, now you can chat with each other. Have fun", withAction: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                })
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            passwordTextfield.resignFirstResponder()
        }
        
        return true
    }
    
    func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Understand", style: .default){
            UIAlertAction in
            alert.dismiss(animated: true, completion: nil)
        })
        
        present(alert, animated: true)
    }
    
    func showDialog(title: String, message: String, withAction: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension String{
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
