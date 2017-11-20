//  Created by Sy Le on 10/12/17.
//  Copyright © 2017 Sy Le. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ViolationConcentrationViewController: UIViewController, CLLocationManagerDelegate {
    // https://stackoverflow.com/questions/43743181/add-marker-label-on-apple-maps-in-swift
    @IBOutlet weak var mapView: MKMapView!
    
    var listNotes: [Note] = []
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    private var annotationCarLocation:[MKPointAnnotation] = []
    
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
        
//        make ajax call and load the pin...
        
        //        get notes...
        let urlStringNote = "\(AppConstant.apiNoteByUserId)/\(currentEmployee.employeeId!)"
        print("Get Note By UserId with URL: \(urlStringNote)")
        
        listNotes = []
        
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
                            } else {
                                // show error
                                print ("Error: apiNoteByUserId: \(AppConstant.apiNoteByUserId)... \(response.error!)")
                            }
                        }
                    }
                } else {
                    print ("Error: apiNoteByUserId: Cannot talk to the Server: \(AppConstant.apiNoteByUserId)... \(response.error!)")
                }
                
                if(self.listNotes.count > 0){
                    for note in self.listNotes {
                        // add annotation...
                        let curAnnomationCarLoc = MKPointAnnotation()
                        curAnnomationCarLoc.coordinate.latitude = note.lat!
                        curAnnomationCarLoc.coordinate.longitude = note.long!
                        curAnnomationCarLoc.title = "License Number: \(note.licenseNumber!)"
                        curAnnomationCarLoc.subtitle = note.description
                        self.mapView.addAnnotation(curAnnomationCarLoc)
                    }
                }
        }
    }
    
    // MARK - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 700, 700)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

