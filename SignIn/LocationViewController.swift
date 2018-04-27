//
//  LocationViewController.swift
//  SignIn
//
//  Created by Pc on 12/18/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {
    
    @IBOutlet var activity: UIActivityIndicatorView!
    private var alerControllerT : alertView?
    
    
    let effectView = UIVisualEffectView()
    
    var locationManager = CLLocationManager()
    var locations  = [CLLocation]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alertController = alertView(title: "Welcome", message: "Press Continue", actionTitle: "Done", completion:  { () in
            self.startLocation()
        })
        
        self.alerControllerT = alertController
        
        // show the popup as initial
        self.addChildViewController(alertController)
        alertController.view.frame = self.view.frame
        self.view.addSubview(alertController.view)
        
        alertController.didMove(toParentViewController: self)
        alertController.addMoreMessage(title: "Why do we Need Location?", message: "Location is taken so when students scan Qr code we can match their location to the class location to verify the student is in class")
        alertController.addMoreMessage(title: "How", message: "On the next page press start taking location and walk up and down the classroom for multiple location because of students sitting in the back of the room")
        
    }
    
    
    
    func startLocation() {
        // set the location manger delegate
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestAlwaysAuthorization()
        
        //activityLoader
        self.activity.isHidden = true
    }
    
    
    @IBAction func tmep(_ sender: Any) {
        self.addChildViewController(alerControllerT!)
        alerControllerT?.view.frame = self.view.frame
        self.view.addSubview((alerControllerT?.view)!)
        alerControllerT?.didMove(toParentViewController: self)
        
        
    }
    
    
    //Button is clickec for start taking location
    @IBAction func startUpdatingLocation(_ sender: Any) {
        
        //unwrap sender as button
        let startTakingLocation = sender as! UIButton
        
        if(!CLLocationManager.locationServicesEnabled()){
            showMessage(title: "Oops", message: "Turn on Location Service", viewController: self, dissappear: false)
        }else{
            //if location should be start taking
            if(startTakingLocation.titleLabel?.text == "Click Here"){
                
                self.locationManager.startUpdatingLocation()
                
                startTakingLocation.setTitle("Finish", for: .normal)
            }
                
                // stop taking location
            else{
                
                //stop taking location
                startTakingLocation.setTitle("Click Here", for: .normal)
                startTakingLocation.sizeToFit()
                
                // saves the locations in the database
                makeDbClal(button:startTakingLocation)
                
                //stop locationManager from taking location
                locationManager.stopUpdatingLocation()
                
                
            }
        }
        
    }
    
    
    
}

// extention of Contoller
extension LocationViewController {
    
    
    //This method is called to make database call
    func makeDbClal(button: UIButton?) {
        
        //hide the button
        button?.isHidden = true
        
        //start the activityLoader
        activity.startAnimating()
        activity.isHidden = false
        
        if(locationAvailable()){
            let postData = makeJson()
            
            let postDictionary = ["json" : postData]
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "teacherHomePage") as! TeachedInViewController
            
            post(postDictionary: postDictionary as NSDictionary,data:postData, url: .location, completionHandler: { (data, response, err) in
                
                if err == nil{
                    let rTrimmed = response.trimmingCharacters(in: NSCharacterSet.whitespaces)
                    if rTrimmed == "success" {
                        
                        let nv = self.navigationController as! TeacherNavigationViewController
                        controller.teacher = nv.teacher
                        
                        self.present(controller, animated: true, completion: nil)
                        
                    }else{
                        showMessage(title: "Oops", message: response, viewController: self, dissappear: false)
                    }
                    
                }else{
                    showMessage(title: "Oops", message: (err?.localizedDescription)!, viewController: self, dissappear: false)
                }
                
            })
            
            
            
            
        }
        
    }
    
    func locationAvailable()  -> Bool {
        if(locations.count == 0){
            showMessage(title: "Wait", message: "Still trying to get your Location", viewController: self, dissappear: false)
            
            return false
        }
        
        return true
    }
    
    func makeJson() -> Data {
        
        var postData = [[String:String]]()
        
        
        postData.append(["locationTable" : "133377_cmsc216_location" ])
        
        for  i in 0..<(locations.count) {
            
            if(i % 2 == 0){
                
                postData.append(["latitude":String(describing:locations[i].coordinate.latitude)
                    ,"longitude":String(describing:locations[i].coordinate.longitude)])
                
                
            }
            
            
            
        }
        
        do {
            let json = try JSONSerialization.data(withJSONObject: postData, options:.prettyPrinted)
            return json
        }
            
        catch {
            
        }
        
        return Data()
        
    }
    
    
}

//this is called when location manager starts updating location
extension LocationViewController : CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //empty locations
        if(self.locations.count < 1) {
            self.locations.append(locations[locations.count-1])
            
        }
        var found = false
        
        //this will be called do duplicate coordinate will not be added
        for location in self.locations {
            if !found && location.coordinate.longitude == locations[locations.count-1].coordinate.longitude &&
                location.coordinate.latitude == locations[locations.count-1].coordinate.latitude {
                found = true
                break
            }
        }
        
     
        
        // no duplicates found
        if(!found) {
            self.locations.append(locations[locations.count-1])
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showMessage(title: "Oops", message: error.localizedDescription, viewController: self, dissappear: false)
    }
    
    
    
}


