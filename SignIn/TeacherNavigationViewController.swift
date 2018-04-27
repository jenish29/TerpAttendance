//
//  TeacherNavigationViewController.swift
//  SignIn
//
//  Created by Pc on 12/17/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit

class TeacherNavigationViewController: UINavigationController {

    var teacher = Teacher()

    
    override func viewWillAppear(_ animated: Bool) {
        self.viewControllers = [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "locationPage")]
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
