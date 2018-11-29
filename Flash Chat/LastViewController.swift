//
//  LastViewController.swift
//  Flash Chat
//
//  Created by Arief Zainuri on 28/11/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class LastViewController: UIViewController {

    var transferedMessage: String?
    var transferedSender: String?
    
    //outlet
    @IBOutlet weak var labelSender: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelSender.text = transferedSender
        messageLabel.text = transferedMessage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func buttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
