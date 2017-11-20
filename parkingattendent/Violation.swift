//
//  Violation.swift
//  parkingattendent
//
//  Created by Sy Le on 10/22/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import Foundation

class Violation {
    var id:String?
    var licenseNumber:String?
    var description:String?
    var violationTime:Date?
    var long:Float?
    var lat:Float?
    var fineAmount:Float?
    var paid:Bool?
    
    
    static func deserializeFromServer(arrayItem: [String:Any]) -> Violation{
        let newItem = Violation()
        newItem.id = arrayItem["id"] as? String
        newItem.licenseNumber = arrayItem["licenseNumber"] as? String
        newItem.description = arrayItem["description"] as? String
        newItem.violationTime = AppUtil.getDateTimeFromTimestamp(timeString: arrayItem["violationTime"] as? String)
        newItem.long = arrayItem["long"] as? Float
        newItem.lat = arrayItem["lat"] as? Float
        newItem.fineAmount = arrayItem["fineAmount"] as? Float
        newItem.paid = arrayItem["paid"] as? Bool
        
        return newItem
    }
}
