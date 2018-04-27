//
//  Teacher.swift
//  SignIn
//
//  Created by Pc on 2/6/17.
//  Copyright © 2017 pc. All rights reserved.
//

import Foundation

class Teacher {
    
    private var jsonArrayOfInfo : [String: Any]?
    
    var info :  [String:Any]? {
        get{
            return jsonArrayOfInfo
        }
        set {
           self.jsonArrayOfInfo = newValue
        }
        
    }
    
  

}
