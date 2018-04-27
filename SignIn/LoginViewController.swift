//
//  LoginViewController.swift
//  SignIn
//
//  Created by pc on 11/5/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet var loginActivity: UIActivityIndicatorView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var accountNeedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginActivity.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func login() {
        
        
        if !emptyCheck() {
            
            let dbUsername = "jkananic_krunal"
            let dbPassword = "krunal123A"
            
            
            loginActivity.isHidden = false
            loginActivity.startAnimating()
            loginButton.isHidden = true
            accountNeedButton.isHidden = true
            
            // create dictionary for user info
            let postDictionary = ["dbUserName":dbUsername,"dbPassword":dbPassword,"username":username.text!,"password":password.text!]
            
            // calls the helper method
            post(postDictionary: postDictionary as NSDictionary,data: nil, url: .login, completionHandler: { (data:Data?, response:String, err:Error?) in
                
                // this will check if there is no error
                if(err == nil){
                    
                    
                    let json = convertToDictionary(text: response);
           
                    if(json != nil){
                    
                        let isStudent = (json?["isStudent"]! as! NSString).doubleValue
                        if (isStudent == 0) {
                            //this is called when teacher is logged in it will create a teacher class object and store info about the teacher within the class and pass the class object as an argument
                            let teacher = Teacher()
                            teacher.info =  json
                            self.performSegue(withIdentifier: "teacherLogin", sender: teacher)
                        }else{
                             self.performSegue(withIdentifier: "login", sender: response)
                        }

                    }else{
                        showMessage(title: "Oops", message: response, viewController: self, dissappear: false)

                    }
                
                
                }
                    // if there is an error it will show message
                else{
                    self.showAlerts(val: true, err: err)
                    
                }
                
                self.loginButton.isHidden = false
                self.accountNeedButton.isHidden = false
                self.loginActivity.stopAnimating()
                self.loginActivity.isHidden = true
                
            } )
            
        }
    }
    

    //login button is pressed
    @IBAction func login(_ sender: Any) {
        login()
    }
    
    // this method will show alert
    func showAlerts(val : Bool, err : Error?){
        
        let alert = UIAlertController()
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        if(err == nil){
            alert.message = "Invalid Username or Password"
            alert.title = "Oops!"
            alert.addAction(action)
            
        }else{
            alert.message = err?.localizedDescription
            alert.title = "Oops!"
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "login" {
            if let destination = segue.destination as? UINavigationController {
                let topControler = destination.topViewController as! TakeAttendanceViewController
                topControler.id = sender as! String
            }
        
            
        }
        
        
        if segue.identifier == "teacherLogin" {
            let object = sender as? Teacher
            
            if let destination = segue.destination as? TeacherNavigationViewController {
        
                destination.teacher = object!
                
            }
            
            
        }
    }
    
    //checks if any username or password is empty
    func emptyCheck() -> Bool {
        if username.text == "" || password.text == "" {
            showALert(title: "Oops", message: "Fields cannot be empty")
            
            return true
        }
        
        return false
        
        
    }
    
    func showALert (title : String, message : String){
        
        let alert = UIAlertController();
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alert.message = message
        alert.title = title
        alert.addAction(action)
        
        self.present(alert,animated:true,completion:nil)
        
        
        
        
        
    }

}
