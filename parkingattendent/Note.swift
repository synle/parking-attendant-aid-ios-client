//
//  Note.swift
//  parkingattendent
//
//  Created by Sy Le on 10/22/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import Foundation

class Note {
    var id:String?
    var licenseNumber:String?
    var description:String?
    var recordTime:Date?
    var long:Double?
    var lat:Double?
    
    init() {}
    
    static func deserializeFromServer(arrayItem: [String:Any]) -> Note{
        let newItem = Note()
        newItem.id = arrayItem["id"] as? String
        newItem.licenseNumber = arrayItem["licenseNumber"] as? String
        newItem.description = arrayItem["description"] as? String
        newItem.recordTime = AppUtil.getDateTimeFromTimestamp(timeString: arrayItem["recordTime"] as? String)
        newItem.long = arrayItem["long"] as? Double
        newItem.lat = arrayItem["lat"] as? Double
        
        return newItem
    }
}
