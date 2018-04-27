//
//  HelperFunctions.swift
//  SignIn
//
//  Created by pc on 11/6/16.
//  Copyright © 2016 pc. All rights reserved.
//

import Foundation
import UIKit

enum urlCase : String {
    case signUp = "http://jkanani.com/php/insert.php"
    case checkAttend = "http://jkanani.com/php/check_attendance.php"
    case takeAttend = "http://jkanani.com/php/add-attendance.php"
  
    case login = "http://jkanani.com/php/PhpFiles/login.php"
    case createStudent = "http://jkanani.com/php/PhpFiles/addStudent.php"
    case newAddClass = "http://jkanani.com/php/PhpFiles/AddClass.php"
    case location = "http://jkanani.com/php/PhpFiles/location.php"
    case getStudents = "http://jkanani.com/php/PhpFiles/GetStudents.php"
    case getLocation = "http://jkanani.com/php/PhpFiles/get_location.php"
    case getDates = "http://jkanani.com/php/PhpFiles/get_dates.php"
    case addDate = "http://jkanani.com/php/PhpFiles/addDateTeachers.php"
}

 func convertToDictionary(text: String) -> [String: Any]? {
  
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
    
    return nil
}

func convertDataToDictionary(data: Data) -> NSMutableDictionary? {
    
    do {
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSMutableDictionary
        
    } catch {
        return nil
    }
    

}

func convertDataToDictionaryArr(data: Data) -> NSArray? {
    
    do {
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSArray
        
    } catch {
        return nil
    }
    
    
}


func post(postDictionary : NSDictionary,data: Data?, url : urlCase,  completionHandler:  @escaping (Data?,String, Error?) -> Swift.Void) {
    
    //creates url request
    var request = URLRequest(url: NSURL(string: url.rawValue) as! URL)
    request.httpMethod = "POST"

    // try catch for json serialization
    do{
        
        //set the http body
        if(data  == nil){
             request.httpBody = try JSONSerialization.data(withJSONObject: postDictionary, options:.prettyPrinted)
        }else{
            request.httpBody = data
        }
       
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response : URLResponse?, err: Error?) in
            
            DispatchQueue.main.sync {
                   var responseString : NSString = "";
                if(err == nil){
            
                        responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                        responseString = responseString.trimmingCharacters(in: .newlines) as NSString
                 
                }
                
                completionHandler(data,responseString as String, err)
            }
         
            
        })
        task.resume()
        
    }catch {
        
    }
    
}

func showMessage(title : String, message: String, viewController : UIViewController,dissappear: Bool) {
    
        let alert = UIAlertController()
        let action =   UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if(dissappear){
                viewController.navigationController?.popToRootViewController(animated: true)
            }
        })
    
  
   
        alert.message = message;
        alert.title = title;
        alert.addAction(action)
    
    
    viewController.present(alert, animated: true, completion: nil)
 
}

func showMessageFinish (title:String, message:String, viewController: UIViewController, completion : @escaping () -> Swift.Void) {
    
    let alert = UIAlertController()
    let action =   UIAlertAction(title: "Ok", style: .default, handler: { (action) in
        completion()
    })

    
    alert.message = message;
    alert.title = title;
    alert.addAction(action)
    
    
    viewController.present(alert, animated: true, completion: nil)
    
}

func isDateSame (date:String) -> Bool{
    let dtF = DateFormatter()
    dtF.dateFormat = "yyyy-MM-dd"
    let dt = dtF.date(from: date)
    

    let calendar = Calendar.current
    
    return calendar.isDateInToday(dt!)
}

func getDate() -> String {
    
    let date = Date()
    let calendar = Calendar.current
    
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    var sMonth = "";
    
    if(month < 10){
        sMonth = "0\(month)"
    }else{
        sMonth = "\(month)"
    }

    let today = "\(year)-\(sMonth)-\(day)"
    
    return today
    
}

extension UIView {
    
    func addConstraintWithFormat(format:String, views: UIView...){
        
        var viewsDictionary = [String:UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
        
    }
    
}
