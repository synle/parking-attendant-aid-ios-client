//  Created by Sy Le on 10/12/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import UIKit
import Alamofire

class AccountViewController: UIViewController {
    @IBOutlet weak var txtEmployeeId: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtFirstName: UILabel!
    @IBOutlet weak var txtLastName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        txtEmployeeId.text = currentEmployee.employeeId
        txtEmail.text = currentEmployee.email
        txtFirstName.text = currentEmployee.firstName
        txtLastName.text = currentEmployee.lastName
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        // reset the user
        currentEmployee = User()
        
        let urlString = AppConstant.apiLogout
        print("Log Out with url: \(urlString)")
        
        // log out...
        Alamofire.request(
            urlString,
            method: .post,
            encoding: JSONEncoding.default,
            headers: [ "Authorization" : AppUtil.getAuthToken() ]
            ).responseJSON { result in
                print("Log out Result: \(urlString)")
                
                if(result.response != nil){
                    print("Log out Result: \(urlString) - \(result.response!.statusCode)")
                }
        }

        // set token
        AppUtil.clearAuthToken()
        
        
        // clear user standard
        UserDefaults.standard.removeObject(forKey: "currentEmployee")
        
    }
}

