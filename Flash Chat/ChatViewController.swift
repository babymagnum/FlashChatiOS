//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageDelivered: String?
    var senderDelivered: String?
    
    @IBOutlet weak var asd: NSLayoutConstraint!
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var currentUser = Auth.auth().currentUser?.email
    
    //dummy data source
    var message = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
                
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        getDataFromFirestore()
    }

    //MARK: - Protocol Function for TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = message[indexPath.row].message
        cell.senderUsername.text = message[indexPath.row].sender
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //index of the cell
        let indexPath = tableView.indexPathForSelectedRow
        
        //object cell of the current row
        let currentCellItem = tableView.cellForRow(at: indexPath!) as! CustomMessageCell
        
        messageDelivered = currentCellItem.messageBody.text!
        senderDelivered = currentCellItem.senderUsername.text!
        
        //heading to detail
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    //MARK: - Prepare for Segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let segue = segue.destination as! LastViewController
            segue.transferedMessage = messageDelivered
            segue.transferedSender = senderDelivered
        }
    }
    
    //MARK: - Text Field Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == messageTextfield {
            messageTextfield.resignFirstResponder()
            
            heightConstraint.constant = 50
            
            view.layoutIfNeeded()
            
            let id = NSUUID().uuidString.lowercased()
            
            insertToFirestore(modelMessage: Message(id: id, message: (messageTextfield.text?.trim())!, sender: currentUser!, imageUrl: "123"))
            
            messageTextfield.text = ""
        }
        
        return true
    }
    
    //MARK: - Handle Outlet Button Pressed
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        //TODO: Send the message to Firebase and save it in our database
        performSegue(withIdentifier: "goToLast", sender: self)
        
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch{
            showDialog(title: "Sign Out Error", message: "There was something error when you perform logout, please check your internet connection and make sure its connected")
        }
    }
    
    //MARK: - Main Functions
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Understand", style: .default){
            (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        present(alert, animated: true)
    }

    //MARK: - Send & Recieve from Firebase
    func insertToFirestore(modelMessage: Message) {
        let data : [String : Any] = [
            "id" : modelMessage.id!,
            "message" : modelMessage.message!,
            "sender" : modelMessage.sender!,
            "imageUrl" : "123",
            "timestamp" : modelMessage.timestamp!
        ]
        
        Firestore.firestore().collection("Message").document(modelMessage.id!).setData(data) {
            (error) in
            if error != nil{
                self.showDialog(title: "Error Sending Message", message: "Please check your internet connection before perform chatting with each other")
            } else{
                print("success")
            }
        }
    }
    
    func getDataFromFirestore() {
        Firestore.firestore().collection("Message").order(by: "timestamp", descending: false).addSnapshotListener {
            (querySnapshot, error) in
            if let err = error {
                print(err)
                self.showDialog(title: "Error Fetching Data", message: "Error when fetching new data from internet, make sure you device is connected to internet")
            } else {
                if (querySnapshot?.documents.count)! > 0{
                    self.message.removeAll()
                    
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        
                        let messageModel = Message(id: data["id"] as! String, message: data["message"] as! String, sender: data["sender"] as! String, imageUrl: data["imageUrl"] as! String)
                        
                        self.message.append(messageModel)
                        
                        self.messageTableView.reloadData()
                        
                        //                    self.messageTableView.insertRows(at: [NSIndexPath(row: self.message.count - 1, section: self.messageTableView.numberOfSections - 1) as IndexPath], with: .left)
                        //
                        //                    self.messageTableView.reloadRows(at: [NSIndexPath(row: self.message.count - 1, section: self.messageTableView.numberOfSections - 1) as IndexPath], with: .left)
                        
                        self.messageTableView.scrollToRow(at: IndexPath(row: self.message.count - 1, section: self.messageTableView.numberOfSections - 1), at: .bottom, animated: true)
                    }
                } else{
                    self.message.removeAll()
                    self.messageTableView.reloadData()
                }
            }
        }
    }
    
}
