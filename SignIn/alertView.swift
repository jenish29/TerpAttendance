//
//  alertView.swift
//  SignIn
//
//  Created by Pc on 12/24/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit

class alertView: UIViewController {
    
    
    private var views = [UIView]()
    private var currentView = 0;
    private var buttonTitle : String?
    private var handler : (() -> Swift.Void)? = nil
    
    convenience init(title:String, message:String, actionTitle: String, completion: (() -> Swift.Void)? = nil){
        self.init()
        
        views.append(UIView())
        
        
        let imageView = UIImageView(image: UIImage(named: "Christmas_lights-9.jpg"))
        imageView.frame = self.view.frame
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)

        let vissualEffect = UIVisualEffectView(frame: self.view.frame)
        vissualEffect.effect = UIBlurEffect(style: .regular)
        view.addSubview(vissualEffect)
       
        //makes a view
        makeView(num: 0, title: title, message: message)
        
        buttonTitle = actionTitle
        
        // assign completion handler
        handler = completion
        
    }
    

    
    // this function will make the popup view
    private func makeView(num : Int, title: String, message : String) {
        
        // add Uiview
        view.addSubview(views[num])
        views[num].backgroundColor = UIColor.white
        views[num].centerVetically(view: self.view, view2: views[num])
        views[num].centerHorizontally(view: self.view, view2: views[num])
        view.addConstraintWithFormat(format: "H:|-40-[v0]-40-|", views: views[num])
        views[num].addHeighet(height: 200, view: views[num])
        
        
        //get the width of the screen and subtract 80 to get width of the popupview
        let viewWidth = view.frame.size.width - 80
        
        // add title label
        let titleLabel = view.createLabel(message: title, width: viewWidth, fontSize: 16)
        titleLabel.textAlignment = .center
        views[num].addSubview(titleLabel)
        titleLabel.centerHorizontally(view: views[num], view2: titleLabel)
        views[num].addConstraintWithFormat(format: "H:[v0(\(viewWidth-40))]", views: titleLabel)
        views[num].addConstraintWithFormat(format: "V:|-20-[v0]", views: titleLabel)
        
        // add the messages label
        let label = view.createLabel(message: message,width: viewWidth, fontSize: 14)
        views[num].addSubview(label)
        views[num].centerHorizontally(view: views[num], view2: label)
        views[num].addConstraintWithFormat(format: "H:[v0(\(viewWidth-30))]", views: label)
        views[num].addConstraintWithFormat(format: "V:[v0]-20-[v1]", views: titleLabel,label)
        
        //adds the button to continue
         let continueButton = UIButton()
        views[num].addSubview(continueButton)
        continueButton.setTitle("Continue", for: .normal)
        
        //if this is the first button to add then we wont have previouse button
        if(num == 0) {
            continueButton.centerHorizontally(view: views[num], view2: continueButton)
            views[num].addConstraintWithFormat(format: "H:[v0(85)]", views: continueButton)
            continueButton.titleLabel?.textAlignment = .center
        }
        
        // we have more than one popup window so we have previouse button to go back
        else {
            
            //changing location of continue button
            views[num].addConstraintWithFormat(format: "H:[v0(85)]-20-|", views: continueButton)
            
            // creating and adding the previouse button to the view
            let previousButton = UIButton()
            previousButton.setTitle("Previous", for: .normal)
            views[num].addSubview(previousButton)
            previousButton.setTitleColor(UIColor.blue, for: .normal)
            previousButton.tag = num
            views[num].addConstraintWithFormat(format: "H:|-20-[v0(85)]", views: previousButton)
            views[num].addConstraintWithFormat(format: "V:[v0]-10-[v1]", views: label,previousButton)
            previousButton.addTarget(self, action: #selector(previousPressed(sender:)), for: .touchUpInside)
            
            continueButton.titleLabel?.textAlignment = .right
            
        }
        
        //adding constraints for the continue button
        continueButton.addHeighet(height: 40, view: continueButton)
        views[num].addConstraintWithFormat(format: "V:[v0]-10-[v1]", views: label,continueButton)
        continueButton.setTitleColor(UIColor.blue, for: .normal)
        continueButton.addTarget(self, action: #selector(continuePressed(sender:)), for: .touchUpInside)
        continueButton.tag = num
        
        
        // extra space needed for the view
        let extra = 30 + title.height(constraintedWidth: viewWidth-40, font: UIFont.systemFont(ofSize: 16)) + 20 + 10
        
        // checks if the popview needs to increase height because of long message
        views[num].needsUpdate(message: message, width: viewWidth, extra: extra)
        
        
        views[num].layer.cornerRadius = 4

    }
    
    func continuePressed(sender: UIButton) {
        
        UIView.animate(withDuration: 0.4) {
            if(sender.tag != self.views.count-1){
                let origin = self.views[sender.tag].frame.origin.x
                self.views[sender.tag].frame.origin.x = self.view.frame.origin.x - self.views[sender.tag].frame.size.width
                self.views[sender.tag + 1].frame.origin.x = origin
                self.currentView += 1
            }
            
            else{
                self.view.removeFromSuperview()
                
                if self.handler != nil {
                    self.handler!()
                }
            }
        }
        
    }
    
    //previous button is pressed
    func previousPressed(sender: UIButton) {
        UIView.animate(withDuration: 0.4) {
            
                let origin = self.views[sender.tag].frame.origin.x
                self.views[sender.tag-1].frame.origin.x = origin
                self.views[sender.tag].frame.origin.x = self.view.frame.maxX + self.views[sender.tag].frame.size.width
                self.currentView -= 1
        }
    }
    
    // add more popups
    func addMoreMessage(title: String, message: String) {
        views.append(UIView())
    
        makeView(num: views.count-1, title: title, message: message)
 
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(currentView == 0){
            views[0].transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
            UIView.animate(withDuration: 0.2) {
                self.views[0].transform = CGAffineTransform.identity
            }
        }
        
     
    }
    override func viewDidLayoutSubviews() {
        
        // making all the views 300 + the screen max size
        for i in 1..<views.count {
            views[i].frame.origin.x = view.frame.maxX + views[i].frame.size.width
            
        }
        
        // makes the last view button equal to user set and make contiue button text dissapear
        let lastView = views[views.count - 1]
        for view in lastView.subviews {
            if let btn = view as? UIButton {
                if(btn.titleLabel?.text == "Continue") {
                    btn.setTitle(buttonTitle!, for: .normal)
                }
            }
        }
        
      
    }
    

    
    
}

extension UIView {
    
    // this function will add height constraint for the give view
    func addHeighet(height : CGFloat,view : UIView){
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
        
        
    }
    
    // this function will add the width constraint for the given view
    func addWidth(width: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
    }
    
    
    // this function can be called if the given view needs to increase height
    func updateHeight(height:CGFloat, view:UIView){
        for constaint in view.constraints {
            if constaint.firstAttribute == NSLayoutAttribute.height
            {
                constaint.constant = height
            }
        }
        
        
    }
   
    // this function will create a label with adjusting width to required number of ines
    func createLabel (message:String, width:CGFloat, fontSize : CGFloat) -> UILabel {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = message
        label.font = UIFont(name: "Arial", size: fontSize)
        label.addHeighet(height: message.height(constraintedWidth: width, font: UIFont.systemFont(ofSize: fontSize)), view: label)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
        
    }
    
    // this function gets called if the popupview needs to increase height
    func needsUpdate(message: String,width:CGFloat, extra: CGFloat) {
        
        let height = message.height(constraintedWidth: width, font: UIFont.systemFont(ofSize: 14)) + extra
        
        if(height >= self.frame.size.height) {
            updateHeight(height: height + 50 , view: self)
        }
       
        
    }
    
    
}
extension String {
    
    // this method returns the height required for the given string
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
    }
    
    // this method returns the width of the given string that is needed
    func width(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let font = font
        let attributes = NSDictionary(object: font, forKey:NSFontAttributeName as NSCopying)
        let sizeOfText = self.size(attributes: (attributes as! [String : AnyObject]))
        
        
        return sizeOfText.width+3
    }
    
    
}
