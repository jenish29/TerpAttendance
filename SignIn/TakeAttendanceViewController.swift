//
//  TakeAttendanceViewController.swift
//  SignIn
//
//  Created by pc on 11/6/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit
import CoreLocation
class TakeAttendanceViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var id : String = ""
    var latitude : String = "";
    var longitude  : String = "";
    
    let locationManager = CLLocationManager()
    
    var currentLongitude : Double?;
    var currentLatitude : Double?;
    
    var locationArr = NSArray()
    let contoller = CameraViewController()
    
    @IBOutlet weak var tableview: UITableView!
    
    var dates = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDates()
        tableview.delegate = self
        tableview.dataSource = self
     
        
        // set the location manger delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func TakeAttendance(_ sender: Any) {
        
        
    }
    
    func verify() {
        self.locationIsEnabled(completion: {
            self.matchLocation(completion: {
                self.calculateDistance(completion: {
                    self.navigationController?.pushViewController(self.contoller, animated: true)
                })
            })
        })
        
    }
    
    func showAlerts(err:Error?){
        let alert = UIAlertController()
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        if(err == nil){
            alert.message = "Your attendance already has been recorded for today"
            alert.title = "Oops!"
            alert.addAction(action)
            
        }
        else{
            alert.message = err?.localizedDescription
            alert.title = "Oops!"
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openCamera" {
            if let destination = segue.destination as? CameraViewController {
                destination.id = id
            }
            
        }
    }
    
    //this fucntion determines how close are you to the class
    func matchLocation (completion: @escaping () -> Swift.Void) {
        
        if (self.locationArr.count != 0) {
            completion()
            return
        }
        
        let dic = convertToDictionary(text: id)
        // create dictionary for user info
        let postDictionary = ["classLocation":dic!["classLoc"]!]
        
        post(postDictionary: postDictionary as NSDictionary,data:nil, url: .getLocation, completionHandler: { (data : Data?, response:String, err:Error?) in
            
            
            // this will check if there is no error
            if(err == nil){
                
                // if the response string is failure then it will show alert
                if(response == "failure"){
                    self.showAlerts(err: err)
                }
                    
                    // moves to the view controller
                else{
                    
                    do {
                        let json =  try JSONSerialization.jsonObject(with: (data)!, options: .mutableContainers) as? NSArray
                        
                        self.locationArr = json!
                        completion()
                        
                    }catch {
                        
                    }
                    
                }
            }
                // if there is an error it will show message
            else{
                self.showAlerts(err: err)
            }
            
            
        })
        
        
        
    }
    
    
    //this function validates if location is enabled
    func locationIsEnabled(completion : @escaping () -> Swift.Void) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showMessage(title: "Oops", message: "Please allow the app to use your location", viewController: self,dissappear: false)
                
            case.authorizedAlways: break;
                
            default: break
            }
            
            if(currentLatitude != nil && currentLongitude !=  nil) {
                completion()
            }
            
        }
            
        else{ showMessage(title: "Wait", message: "Still obtaining your location", viewController: self,dissappear:false) }
        
    }
    
    
    // this method is called after getting locations for the class from the table and it will check whether or not student is in class
    func calculateDistance (completion : @escaping () -> Swift.Void) {
        for i in 0..<locationArr.count {
            
            self.latitude = ((locationArr[i]) as AnyObject).value(forKey: "latitude") as! String
            self.longitude = ((locationArr[i]) as AnyObject).value(forKey: "longitude") as! String
            
            
            let coordinate = CLLocation(latitude:currentLatitude!,longitude:currentLongitude!)
            let coordinate2 = CLLocation(latitude: Double(longitude)!, longitude: Double(latitude)!)
            
            let distance = coordinate.distance(from: coordinate2) * 0.000621371192
            
            if(distance < 0.1) {
                completion()
                return
            }
            
            
        }
        
        showMessage(title: "Oops", message: "Come to class to take your attendance", viewController: self,dissappear: false)
        
    }
    
    private func getDates() {
        let dic = convertToDictionary(text: id)
        // create dictionary for user info
        let postDictionary = ["classMainAtt":dic!["classMAtt"],"classAtt":dic!["classAtt"]!,"id":dic!["id"]!,"today":getDate()]
        
        post(postDictionary: postDictionary as NSDictionary, data: nil, url: .getDates) { (data, response, err) in
            if(err == nil) {
                
                let json = convertDataToDictionaryArr(data: data!)
                
                if(json != nil) {
                    
                    self.dates = json!
                    self.tableview.reloadData()
                    self.appendToday()
                }else{
                    self.getDates()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showMessage(title: "Something went wrong", message: "Location Obtain failed", viewController: self,dissappear: false)
    }
    
    //location starts updating
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count-1]
        
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Dates
        if(dates.count > 0){
            let dt = dates[indexPath.row] as! NSDictionary
            
            cell.date.text = (dt["date"] as! String)
            
            if((dt["taken_att"] as! String) == "1") {
                cell.view.backgroundColor = UIColor.green.withAlphaComponent(0.3)
                
            }else if indexPath.row != 0 {
                cell.view.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! Dates
        
 
        if(isDateSame(date: cell.date.text!)) {
            verify()
        }else{
            showMessage(title: "Oops", message: "Cant take For Selected Date", viewController: self, dissappear: false)
        }
      
    }

    func appendToday() {
        if dates.count == 0 {
            return
        }
        
        let dt = dates[0] as! NSDictionary
        let dtF = DateFormatter()
        dtF.dateFormat = "yyyy-MM-dd"
        
        let td = dtF.date(from: dt["date"] as! String)
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        if calendar.isDateInToday(td!) == false {
            let today = "\(year)-\(month)-\(day)"
            let arr : NSArray = [["date":today,"taken_att":"1"]]
            let newarr = arr.addingObjects(from: dates as! [Any])
            dates = newarr as NSArray
            
        }
        
        
    }
    
    
    
}

class Dates : UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var view: UIView!
}
