//
//  LoginViewController.swift
//  parkingattendent
//
//  Created by Sy Le on 10/15/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

var currentEmployee:User = User()

class LoginViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // retrieve from previous data...
        if let dataCurrentEmployee = UserDefaults.standard.data(forKey: "currentEmployee") {
            let myCurrentEmployee:User? = NSKeyedUnarchiver.unarchiveObject(with: dataCurrentEmployee) as? User
            
            if ( myCurrentEmployee != nil) {
                currentEmployee = myCurrentEmployee!
                
                // set token
                AppUtil.setAuthToken(newAuthToken: currentEmployee.authToken!)
                
                if (!(currentEmployee.employeeId?.isEmpty)!){
                    // move to next step
                    continueToMainApp()
                }
            }
        }
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let inputEmail:String = txtEmail.text!
        let inputPassword:String = txtPassword.text!
        
        if ( inputEmail.isEmpty || inputPassword.isEmpty ){
            let alertController = AppUtil.showMessageAlert(
                alertTitle: "Error",
                alertMessage: "Email and Password required for login...",
                alertActionBtnText: "Dismiss"
            )
            
            self.present(alertController, animated: false, completion: nil)
            
            return false
        }
        
        // do ajax calls to get the employee name and stuffs...
        // https://stackoverflow.com/questions/31982513/how-to-send-a-post-request-with-body-in-swift
        let urlString = AppConstant.apiLogin
        print("Log In with URL: \(urlString)")
        
        
        // make ajax call to upload...
        Alamofire.request(
            urlString,
            method: .post,
            parameters: [
                "username": inputEmail,
                "password": inputPassword
            ],
            encoding: JSONEncoding.default
        ).responseJSON { response in
            var alertController:UIAlertController? = nil
            
            if (response.error == nil){
                if let responseDictionary = response.value as? [String: AnyObject] {
                    let responseSuccess = responseDictionary["success"] as! Bool
                    
                    if(responseSuccess == true){
                        let responseValue = responseDictionary["value"] as! [String: AnyObject]
                        
                        currentEmployee.employeeId = responseValue["id"] as? String
                        currentEmployee.authToken = responseValue["token"] as? String
                        currentEmployee.email = responseValue["email"] as? String
                        currentEmployee.firstName = responseValue["firstName"] as? String
                        currentEmployee.lastName = responseValue["lastName"] as? String
                        
                        // archive login users
                        let encodedCurrentEmployee = NSKeyedArchiver.archivedData(withRootObject: currentEmployee)
                        UserDefaults.standard.set(encodedCurrentEmployee, forKey: "currentEmployee")
                        
                        
                        // set token
                        AppUtil.setAuthToken(newAuthToken: currentEmployee.authToken!)
                        
                        // move to next step
                        self.continueToMainApp()
                    } else {
                        // show error
                        alertController = AppUtil.showMessageAlert(
                            alertTitle: "Error",
                            alertMessage: "Invalid username or password...",
                            alertActionBtnText: "Dismiss"
                        )
                    }
                }
            } else {
                print ("Cannot talk to the Server... \(response.error!)")
                
                alertController = AppUtil.showMessageAlert(
                    alertTitle: "Error",
                    alertMessage: "Server is not reachable...",
                    alertActionBtnText: "Dismiss"
                )
            }
            
            // show alert if needed
            if(alertController != nil) {
                self.present(alertController!, animated: false, completion: nil)
            }
        }
        
        
        // don't auto redirect segue, codes...
        return false;
    }
    
    func continueToMainApp(){
        self.performSegue(withIdentifier: "segue_login", sender: self)
    }
}

