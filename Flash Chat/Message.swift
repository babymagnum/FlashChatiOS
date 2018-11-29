//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message

import UIKit

class Message {
    var id: String?
    var message: String?
    var sender: String?
    var imageUrl: String?
    var timestamp: Int?
    
    init(id:String, message:String, sender:String, imageUrl:String) {
        self.id = id
        self.message = message
        self.sender = sender
        self.imageUrl = imageUrl
        self.timestamp = self.currentTimeInMilliSeconds()
    }
    
    func currentTimeInMilliSeconds()-> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
}
