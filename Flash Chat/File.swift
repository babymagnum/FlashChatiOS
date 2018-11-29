//
//  File.swift
//  Flash Chat
//
//  Created by Arief Zainuri on 27/11/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class File{
    var id: String?
    var firstName: String?
    var lastName: String?
    var age: Int?
    var address: String?
    
    init(id:String, firsName:String, lastName:String, age:Int, address:String) {
        self.id = id
        self.firstName = firsName
        self.lastName = lastName
        self.age = age
        self.address = address
    }
}
