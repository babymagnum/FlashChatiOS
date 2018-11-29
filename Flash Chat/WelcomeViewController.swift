//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import FirebaseAuth


class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToChat", sender: self)
        }
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.tag == 2 {
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
    }
}
