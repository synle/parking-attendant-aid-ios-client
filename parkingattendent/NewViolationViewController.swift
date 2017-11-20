import UIKit
import MapKit
import Alamofire

class NewViolationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtLicense: UITextField!
    @IBOutlet weak var txtFineAmount: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var txtCurrentTime: UILabel!
    
    let numberFormatter = NumberFormatter()

    
    private var currentTime: Date = Date()
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    private var annotationCarLocation:MKPointAnnotation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        https://stackoverflow.com/questions/25449469/swift-show-current-location-and-update-location-in-a-mkmapview
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
//        numberFormatter.numberStyle = NumberFormatter.Style.DecimalStyle
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        reset values
        currentTime = Date()
        txtCurrentTime.text! = AppUtil.getDateTimeFriendlyString(date: currentTime)
        txtLicense.text = ""
        txtNote.text = ""
        txtFineAmount.text = ""
        
        // focus on license box...
        txtLicense.becomeFirstResponder()
    }
    
    
    // MARK - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 700, 700)
                mapView.setRegion(viewRegion, animated: false)
                
                //                // remove previous annotation
                if(annotationCarLocation != nil){
                    mapView.removeAnnotation(annotationCarLocation!)
                }
                
                // add current location
                let curAnnomationCarLoc = MKPointAnnotation()
                curAnnomationCarLoc.coordinate = userLocation.coordinate
                curAnnomationCarLoc.title = "Current Car Location"
                curAnnomationCarLoc.subtitle = "\(userLocation.coordinate.latitude) / \(userLocation.coordinate.longitude)"
                mapView.addAnnotation(curAnnomationCarLoc)
                annotationCarLocation = curAnnomationCarLoc
            }
        }
    }
    
    @IBAction func onSaveNewNote(_ sender: Any) {
        let inputLicenseNumber:String = txtLicense.text!
        let inputNote:String = txtNote.text!
        let inputCurrentTime = AppUtil.getEpochTimeStampFromDate(dateTimeObject: currentTime)
        let inputFineAmount:Float = numberFormatter.number(from: txtFineAmount.text!) as! Float

        
        //                https://stackoverflow.com/questions/35472917/alamofire-header-parameters
        //        https://stackoverflow.com/questions/39490839/alamofire-swift-3-0-extra-parameter-in-call
        let urlString = AppConstant.apiViolation
        print("Create Violation with URL: \(urlString)")
        
        
        Alamofire.request(
            urlString,
            method: .post,
            parameters: [
                "licenseNumber": inputLicenseNumber,
                "description": inputNote,
                "violationTime": inputCurrentTime,
                "long": currentLocation?.coordinate.longitude ?? 0,
                "lat": currentLocation?.coordinate.latitude ?? 0,
                "fineAmount": inputFineAmount,
                "paid": false
            ],
            encoding: JSONEncoding.default,
            headers: ["Authorization": currentEmployee.authToken!]
            ).responseJSON { response in
                var alertController:UIAlertController? = nil
                
                if (response.error == nil){
                    if let responseDictionary = response.value as? [String: AnyObject] {
                        let responseSuccess = responseDictionary["success"] as! Bool
                        
                        if(responseSuccess == true){
                            // show success
                            alertController = AppUtil.showMessageAlert(
                                alertTitle: "Success",
                                alertMessage: """
                                    inputCurrentTime=\(inputCurrentTime),
                                    inputLicenseNumber=\(inputLicenseNumber),
                                    inputFineAmount=\(inputFineAmount),
                                """,
                                alertActionBtnText: "Dismiss"
                            )
                            
                            // clear it
                            self.viewDidAppear(false)
                        } else {
                            // show error
                            alertController = AppUtil.showMessageAlert(
                                alertTitle: "Error",
                                alertMessage: "Cannot create note...",
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
    }
    
    @IBAction func onCancelNewRecord(_ sender: Any) {
        txtLicense.text = ""
        
        // focus on license box...
        txtLicense.becomeFirstResponder()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

