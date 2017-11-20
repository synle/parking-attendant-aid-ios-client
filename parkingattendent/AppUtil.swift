//
//  AppUtil.swift
//  parkingattendent
//
//  Created by Sy Le on 10/15/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


var authToken:String = ""


// conver to api for creating new date
let dateFormatter1 = DateFormatter()

// for convert api for reading...
let dateFormatter2 = DateFormatter()

class AppUtil {
    
    // to show alert message
    /*
     let alertController = AppUtil.showMessageAlert(
        alertTitle: "Error",
        alertMessage: "Please enter the Employee ID",
        alertActionBtnText: "Dismiss"
     )
     
     present(alertController, animated: true, completion: nil)
     */
    static func showMessageAlert(alertTitle: String, alertMessage: String, alertActionBtnText: String) -> UIAlertController{
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .    alert)
        let defaultAction = UIAlertAction(title: alertActionBtnText, style: .default, handler: nil)
        alertController.addAction(defaultAction)
    
        return alertController
    }
    
    // apiUrlString /api/...
    static func getResourceUrl(apiUrl: String) -> String{
//        192.168.1.11
//        let appUrl:String = "http://192.168.1.11:8080"
        let appUrl:String = "http://localhost:8080"
        return "\(appUrl)\(apiUrl)"
    }
    
    
    static func toJSonString(data : Any) -> String {
        var jsonString = "";
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonString;
    }
    
    // access token
    static func clearAuthToken(){
        authToken = ""
    }
    
    static func setAuthToken(newAuthToken: String){
        authToken = newAuthToken
    }
    
    static func getAuthToken() -> String{
        return authToken
    }
    
    
    // other common util...
    static func getEpochTimeStampFromDate(dateTimeObject: Date) -> NSNumber {
        let tempTimeInt = dateTimeObject.timeIntervalSince1970
        return (ceil(tempTimeInt) * 1000 as? NSNumber)!
    }
    
    static func getCurrentTimeFriendlyString() -> String{
        let currentTime:Date = Date()
        return AppUtil.getDateTimeFriendlyString(date: currentTime)
    }
    
    
    static func getDateTimeFriendlyString(date: Date) -> String{
        dateFormatter1.dateFormat = "MM/dd/YYYY h:mm a"
        
        // hard code to PST: -8 (3600)
        dateFormatter1.timeZone = TimeZone(secondsFromGMT: -25200)
        
        let dateString = dateFormatter1.string(from: date)
        return dateString
    }
    
    
    static func getDateFriendlyString(date: Date) -> String{
        dateFormatter1.dateFormat = "MM/dd"
//        dateFormatter1.dateFormat = "MM/dd/YYYY"
        
        // hard code to PST: -8 (3600)
        dateFormatter1.timeZone = TimeZone(secondsFromGMT: -25200)
        
        let dateString = dateFormatter1.string(from: date)
        return dateString
    }

    
    
    static func getDateTimeFromTimestamp(timeString: String?) -> Date?{
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        // hard code to PST: -8 (3600)
        dateFormatter1.timeZone = TimeZone(secondsFromGMT: -25200)
        
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter2.date(from: timeString!)
    }
}
