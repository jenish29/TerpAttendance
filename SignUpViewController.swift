//
//  SignUpViewController.swift
//  SignIn
//
//  Created by Pc on 12/9/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{

    let pickerViewData  = ["Student","Teacher"]
    //main view
    let topView : UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 58/255, green: 119/255, blue: 255/255, alpha: 1)
        return view
    
    }()
    
    //username textfiled
    let username : UITextField = {
       
        let textFiled = UITextField()
        textFiled.placeholder = "Username"
        textFiled.backgroundColor = UIColor.white
        textFiled.textColor = UIColor.black
        textFiled.layer.cornerRadius = 15
        textFiled.clipsToBounds = true
        
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        paddingLeft.layer.cornerRadius = 15
        textFiled.leftView = paddingLeft
        textFiled.leftViewMode = UITextFieldViewMode.always

        
        return textFiled
        
    }()
    
    //signup button
    let signUp : UIButton = {
       let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.black, for: .highlighted)
        return button
        
    }()
    
    //choosing between student and teacher
    let pickerView : UIPickerView = {
       
        let pickerView = UIPickerView()
        pickerView.numberOfRows(inComponent: 2)
        pickerView.selectedRow(inComponent: 0)

        return pickerView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        view.addSubview(topView)
        topView.frame = view.frame
        
        
        //add username textfield
        topView.addSubview(username)
        topView.addConstraintWithFormat(format: "H:[v0(150)]", views: username)
        topView.addConstraintWithFormat(format: "V:|-100-[v0(30)]", views: username)
        topView.centerHorizontally(view: self.topView, view2: username)
    
        //add signup button
        topView.addSubview(signUp)
        topView.addConstraintWithFormat(format: "H:[v0(90)]", views: signUp)
        topView.addConstraintWithFormat(format: "V:[v0(30)]", views: signUp)
        topView.centerVetically(view: self.view, view2: signUp)
        topView.centerHorizontally(view: self.view, view2: signUp)
        signUp.addTarget(self, action: #selector(sign), for: .touchUpInside)
      
        topView.addSubview(pickerView)
        topView.addConstraintWithFormat(format: "H:[v0(100)]", views: pickerView)
        topView.addConstraintWithFormat(format: "V:[v0(60)]-0-[v1]", views: pickerView,signUp)
        topView.centerHorizontally(view: self.topView, view2: pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
    
        
       
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // sign up button is pressed
    func sign(sender : UIButton) {
   
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
    

}



extension UIView {
    
    func centerHorizontally (view : UIView, view2 : UIView) {
        let constriant = NSLayoutConstraint(item: view2, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(constriant)
        
    }
    
    func centerVetically (view : UIView, view2: UIView){
        let constriant = NSLayoutConstraint(item: view2, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(constriant)
    }
}
