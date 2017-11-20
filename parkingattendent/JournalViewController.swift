//  Created by Sy Le on 10/12/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import UIKit
import Alamofire

class JournalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblFilterMode: UILabel!
    
    var showNoteOnly = true
    var listNotes: [Note] = []
    var listViolations: [Violation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(){
        listNotes = []
        listViolations = []
    
        if(showNoteOnly){
            lblFilterMode.text = "Showing Notes created by you"
        } else {
            lblFilterMode.text = "Showing Violations created by you"
        }
        
//        get notes...
        let urlStringNote = "\(AppConstant.apiNoteByUserId)/\(currentEmployee.employeeId!)"
        print("Get Note By UserId with URL: \(urlStringNote)")
        
        // get notes
        Alamofire.request(
            urlStringNote,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": currentEmployee.authToken!]
        ).responseJSON { response in
            if (response.error == nil){
                if let responseDictionary = response.value as? [String: AnyObject] {
                    if let responseSuccess = responseDictionary["success"] as! Bool!,
                        let responseValue = responseDictionary["value"] as! [[String: AnyObject]]! {
                        if(responseSuccess == true){
                            // show success
                            // update data...
                            for arrayItem in responseValue {
                                let newItem = Note.deserializeFromServer(arrayItem: arrayItem)
                                self.listNotes.append(newItem)
                            }
                            
                            // print new note count
                            print ("Success: apiNoteByUserId Note List Count: \(self.listNotes.count)")
                            
                            
                            self.tableView.reloadData()
                        } else {
                            // show error
                            print ("Error: apiNoteByUserId: \(AppConstant.apiNoteByUserId)... \(response.error!)")
                        }
                    }
                }
            } else {
                print ("Error: apiNoteByUserId: Cannot talk to the Server: \(AppConstant.apiNoteByUserId)... \(response.error!)")
            }
        }
        
        
        
        
//        get violations...
        let urlStringViolation = "\(AppConstant.apiViolationByUserId)/\(currentEmployee.employeeId!)"
        print("Get Violations By UserId with URL: \(urlStringViolation)")
        Alamofire.request(
            urlStringViolation,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: ["Authorization": currentEmployee.authToken!]
            ).responseJSON { response in
                if (response.error == nil){
                    if let responseDictionary = response.value as? [String: AnyObject] {
                        if let responseSuccess = responseDictionary["success"] as! Bool!,
                            let responseValue = responseDictionary["value"] as! [[String: AnyObject]]! {
                            if(responseSuccess == true){
                                // show success
                                // update data...
                                for arrayItem in responseValue {
                                    let newItem = Violation.deserializeFromServer(arrayItem: arrayItem)
                                    self.listViolations.append(newItem)
                                }
                                
                                // print new note count
                                print ("Success: apiViolation: Violations List Count: \(self.listViolations.count)")
                                
                                
                                self.tableView.reloadData()
                            } else {
                                // show error
                                print ("Error: apiViolation: \(AppConstant.apiNoteByUserId)... \(response.error!)")
                            }
                        }
                    }
                } else {
                    print ("Error: apiViolation: Cannot talk to the Server: \(AppConstant.apiNoteByUserId)... \(response.error!)")
                }
        }
    }
    
    
    @IBAction func onClickShowNoteOnly(_ sender: Any) {
        showNoteOnly = true
        refreshData()
    }
    
    @IBAction func onClickShowViolationOnly(_ sender: Any) {
        showNoteOnly = false
        refreshData()
    }
    
    
    
    //    for the table view data source
//    count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(showNoteOnly){
            return listNotes.count
        }
        return listViolations.count
    }
    
//    select event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let rowIdx = indexPath.row
        var alertController:UIAlertController? = nil
        
        if(showNoteOnly){
            let matchedItem = listNotes[rowIdx]
            
            alertController = AppUtil.showMessageAlert(
                alertTitle: "Note For: \(matchedItem.licenseNumber!)",
                alertMessage: """
                    RecordTime: \(AppUtil.getDateTimeFriendlyString(date: matchedItem.recordTime!)) \n
                    Description: \(matchedItem.description!) \n
                """,
                alertActionBtnText: "Dismiss"
            )
        } else {
            let matchedItem = listViolations[rowIdx]
            
            alertController = AppUtil.showMessageAlert(
                alertTitle: "Violation Description For: \(matchedItem.licenseNumber!)",
                alertMessage: """
                    ViolationTime: \(AppUtil.getDateTimeFriendlyString(date: matchedItem.violationTime!)) \n
                    Fine Amount: $\(matchedItem.fineAmount!) \n
                    Description: \(matchedItem.description!) \n
                """,
                alertActionBtnText: "Dismiss"
            )
        }
        
        // show alert if needed
        if(alertController != nil) {
            self.present(alertController!, animated: false, completion: nil)
        }
    }

    
//    rednering
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote", for: indexPath )

        if (showNoteOnly){
            if listNotes.count > 0 {
                let matchedItem = listNotes[indexPath.row]
                cell.textLabel?.text = """
                    \(AppUtil.getDateFriendlyString(date: matchedItem.recordTime!)) - \(matchedItem.licenseNumber ?? "") - \(matchedItem.description ?? "")
                """
            }
        } else {
            if listViolations.count > 0 {
                let matchedItem = listViolations[indexPath.row]
                cell.textLabel?.text = """
                    \(AppUtil.getDateFriendlyString(date: matchedItem.violationTime!)) - \(matchedItem.licenseNumber ?? "") - \(matchedItem.description ?? "")
                """
            }
        }
        
        return cell
    }
}

