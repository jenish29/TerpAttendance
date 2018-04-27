//
//  SignInViewController.swift
//  SignIn
//
//  Created by pc on 11/2/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController,UITextFieldDelegate,UIWebViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    
    private let pickerViewData  = ["Student","Teacher"]
    private var shouldMove = true
    
    @IBOutlet private var signUpLabel: UILabel!
    @IBOutlet private var topView: UIView!
    @IBOutlet private weak var username: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var id: UITextField!
    @IBOutlet private weak var signUpButt: UIButton!
    @IBOutlet private var classId: UITextField!
    @IBOutlet private var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.topView.autoresizesSubviews  = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
    }
    
    
    @IBAction private func SignUp(_ sender: Any) {
        if(emptyCheck()){
            validityAlert(message: "Fields cannot be empty")
        }else if (checkValidty()){
            signUp()
            username.resignFirstResponder()
            password.resignFirstResponder()
            email.resignFirstResponder()
            id.resignFirstResponder()
        }
        
        
    }
    
    //this function check if all the inputs are valid
    
    private func checkValidty() -> Bool{
        
        //return true false if email field doesn't contain @ or .
        if(!((email.text?.contains("@"))! || !(email.text?.contains("."))!)){
            validityAlert(message: "Email not valid")
            return false
        }
            
            //if email contains . or @ check if placement is valid and return true if else false
        else {
            
            // index of @
            var atIndex = -1
            //index of .
            var dotIndex = -1
            // keep track where of index
            var count = 0
            var emaileAddr = email.text!
            
            for i in (emaileAddr.characters.indices) {
                count += 1
                
                if(emaileAddr[i] == "@"){
                    atIndex = count - 1
                }
                
                if(emaileAddr[i] == "."){
                    dotIndex = count - 1
                }
                
                if(atIndex != -1 && dotIndex != -1){
                    break
                }
            }
            
            if(atIndex + 1 <= dotIndex-1 && atIndex != 0){
                return true
            }
            
            validityAlert(message: "Email not valid")
            return false
            
            
            
        }
        
        
    }
    
    private func isNum () -> Bool {
        let sid = Int (id.text!)
        let cId = Int (classId.text!)
        
        if(sid == nil || cId == nil) {
            validityAlert(message: "Id must be Number")
            return false
        }else{
            return true
        }
        
    }
    
    private func validityAlert(message:String){
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style:.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func emptyCheck() -> Bool {
        if(username.text == "" || password.text == "" || email.text == "" || id.text == ""){
            return true
        }
        
        return false
    }
    
    
    
    // this function will post to database creting a new user if it can
    private func signUp(){
        
        if picker.selectedRow(inComponent: 0) == 1 {
            createTeacher()
        }else{
            if(isNum()){
                creatStudent()
            }
        }
        
        
        
    }
    
    
    // if studet is signing up
    private func creatStudent() {
        
        let user = username.text!
        let pass = password.text!
        let em = email.text!
        let dbUsername = "jkananic_krunal"
        let dbPassword = "krunal123A"
        let cId = classId.text!
        let studentId = id.text!
        
        let postDictionary = ["dbUser": dbUsername,"dbPassword":dbPassword, "username":user, "password":pass, "classId": cId, "email" : em , "studentId" : studentId] as NSDictionary
        
        post(postDictionary: postDictionary,data:nil, url: .createStudent) { (data: Data?, response:String, err : Error?) in
            if(err == nil){
                let stringTocompare = "success"
                let responseTrimmed = response.trimmingCharacters(in: NSCharacterSet.whitespaces)
                
                if(responseTrimmed == stringTocompare){
                    showMessage(title: "Great", message: response, viewController: self, dissappear: true)
                }else{
                    showMessage(title: "Oops", message: response, viewController: self, dissappear: false)
                }
            }
                
            else{
                showMessage(title: "Oops", message: (err?.localizedDescription)!, viewController: self, dissappear: false)
            }
        }
        
        
    }
    
    // if teacher is signing up
    private func createTeacher () {
        
        let user = username.text!
        let pass = password.text!
        let cname = id.text!
        let em = email.text!
        let dbusername = "jkananic_krunal"
        let dbpassword = "krunal123A"
        
        let postDictionary = ["dbUser":dbusername,"dbPassword":dbpassword,"username":user,"password":pass,"className":cname,"email":em]
        
        post(postDictionary: postDictionary as NSDictionary,data:nil, url: .newAddClass, completionHandler: { (data:Data?, response:String, err:Error?) in
            
            if(err == nil){
                
                let stringTocompare = "success"
                //created a new ueser
                if(response == stringTocompare){
                    showMessage(title: "Great", message: "You have Created a Class Login in to View your Unique Class Id", viewController: self,dissappear: true)
                    
                }
                    
                    //something happened
                else{
                    showMessage(title: "Oops", message: response, viewController: self,dissappear: false)
                }
            }else{
                showMessage(title: "Something Happened", message: (err?.localizedDescription)!, viewController: self,dissappear: false)
            }
        })
        
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //method is called when pickerView changed selection
        if(row == 1){
            
            //teacher is selected
            id.placeholder = "Class Name"
            
            //hid the class id
            classId.isHidden = true
            
            // move the view up
            pickerView.frame.origin.y = classId.frame.origin.y
            signUpButt.frame.origin.y = pickerView.frame.maxY
            
        }else{
            
            //change the id for students
            id.placeholder = "id"
            
            // show the class id field
            classId.isHidden = false
            
            // move the views down
            pickerView.frame.origin.y = classId.frame.maxY
            signUpButt.frame.origin.y = pickerView.frame.maxY
            
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if self.view.frame.origin.y == 0 {
            
            if(shouldMove && UIScreen.main.bounds.size.height <= 1000) {
                
                var amountToMove = self.topView.frame.origin.y - (self.signUpLabel.frame.maxY - (self.navigationController?.navigationBar.frame.maxY)! + 20)
                
                if(UIScreen.main.bounds.size.height >= 667){
                    amountToMove = self.topView.frame.origin.y -  (self.navigationController?.navigationBar.frame.maxY)!
                }
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.topView.frame.origin.y = amountToMove
                    self.shouldMove = false
                })
                
            }
        }
        
    }
    
    
    
    
    
    
    
}
