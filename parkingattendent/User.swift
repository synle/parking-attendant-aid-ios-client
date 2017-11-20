//
//  User.swift
//  parkingattendent
//
//  Created by Sy Le on 10/15/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import Foundation


// https://stackoverflow.com/questions/37980432/swift-3-saving-and-retrieving-custom-object-from-userdefaults
class User: NSObject, NSCoding {
    var employeeId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var authToken: String?
    
    override init(){}
    
    init(
        employeeId: String?,
        firstName: String?,
        lastName: String?,
        email: String?,
        authToken: String?
        ) {
        self.employeeId = employeeId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.authToken = authToken
    }
    
    required init(coder decoder: NSCoder) {
        self.employeeId = decoder.decodeObject(forKey: "employeeId") as? String ?? ""
        self.firstName = decoder.decodeObject(forKey: "firstName") as? String ?? ""
        self.lastName = decoder.decodeObject(forKey: "lastName") as? String ?? ""
        self.email = decoder.decodeObject(forKey: "email") as? String ?? ""
        self.authToken = decoder.decodeObject(forKey: "authToken") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(employeeId, forKey: "employeeId")
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(email, forKey: "email")
        coder.encode(authToken, forKey: "authToken")
    }
}
