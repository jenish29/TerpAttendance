//
//  TeachedInViewController.swift
//  SignIn
//
//  Created by Pc on 2/7/17.
//  Copyright © 2017 pc. All rights reserved.
//

import UIKit
let v = UIView()

class TeachedInViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak private var className: UILabel!
    @IBOutlet weak private var idLabel: UILabel!
    @IBOutlet weak private var viewIDBt: UIButton!
    @IBOutlet weak private var idView: UIView!
    @IBOutlet weak private var classNameViewBt: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var shouldFilter = false
    var teacher = Teacher()
    var json: NSMutableArray? = nil
    
    var names = [String]()
    var filterNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTopView()
        update(limit1: 24, limit2: 0)
    }
    
    private func update(limit1:Int, limit2:Int ){
        let dictionary = ["studentTable" : teacher.info?["usertable"] as! String,"limit1":limit1,"limit2":limit2] as [String : Any]
        
        post(postDictionary: dictionary as NSDictionary, data: nil, url: .getStudents) { (data, response, err) in
            
            let json = convertDataToDictionary(data: data!)
            
            if(json != nil){
                var before : Int = 0
          
                if(self.json != nil) {
                    before = (self.json?.count)!;
                    let  arr = json!["arr"] as! NSArray
                    self.json?.addObjects(from: arr as! [Any])
                   
                }else{
                    
                    self.json = json?["arr"]! as? NSMutableArray
                    
                }
               
                let after = (self.json?.count)!
                
                for index in before..<after {
                    let inde = self.json?[index] as! NSMutableDictionary
                    self.names += [inde["username"] as! String]
                    
                }
                
                   self.tableView.reloadData()
                
                if let nsarr = json!["arr"] {
            
                    if (nsarr as! NSArray).count == 24 {
                   
                        self.update(limit1: limit1, limit2: limit2 + 24)
                    }else{
                       print(self.names.count)
                        self.tableView.reloadData()
                        
                       
                    }
                }
                
            }else{
                showMessage(title: "Oops", message: response, viewController: self, dissappear: false)
            }
        }
        
        

    }
    
    // if id label doesnt fit in the screen then user can press this and it will show more info about the user
    @IBAction private func showInfo(_ sender: Any) {
        let info = teacher.info!
     
        showMessage(title: "Your class id is:", message: info["id"] as! String, viewController: self, dissappear: false)
        
    }
    
    // shows classname as a alert
    @IBAction private func showCName(_ sender: UIButton) {
        let info = teacher.info!
        
        showMessage(title: "Your class name is:", message: info["classname"] as! String, viewController: self, dissappear: false)
        
    }
    
    private func makeTopView(){
        let info = teacher.info!
        
        let text  = (info["id"] as? String)!
        if labelGreaterThenWidth(text: text, label: idLabel,view: idView)
        {
            idLabel.isHidden = true
            viewIDBt.isHidden = false
        }else
        {
            viewIDBt.isHidden = true
            idLabel.text = text
            
        }
        
        let cName = (info["classname"] as? String)!
        
        if labelGreaterThenWidth(text: cName, label: className, view: headerView)
        {
            className.isHidden = true
            classNameViewBt.isHidden = false
        }else {
            className.text = (info["classname"] as? String)!
            classNameViewBt.isHidden = true
        }
  
    }
    
    private func labelGreaterThenWidth (text:String,label:UILabel,view:UIView)->Bool {
        
        let width = text.width(constraintedWidth: idLabel.frame.maxX, font: UIFont.systemFont(ofSize: 15))
      
        return width > view.frame.maxX - label.frame.origin.x
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! Cell
        
        if let json = self.json {
  
        let arr = json[indexPath.row] as! NSMutableDictionary
        
        if(!shouldFilter) {
            cell.email.text = arr["email"] as? String
            cell.id.text = arr["id"] as? String
            cell.name.text = arr["username"] as? String
        }
        else{
            cell.name.text = filterNames[indexPath.row]
        }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        if(shouldFilter) {
            return filterNames.count
        }
        else if let json = self.json {
            return json.count
        }

        return 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! Cell

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "datesViewController") as! TableViewForTeacherViewingStudents
        
        controller.dic = teacher.info!
        controller.id = cell.id.text!
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      
       shouldFilter = false
       tableView.reloadData()
       searchBar.resignFirstResponder()
       searchBar.showsCancelButton = false
       searchBar.text = ""
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        shouldFilter = true
        
        if searchText == "" {
            shouldFilter = false
            tableView.reloadData()
        }
        else{
            searchBar.showsCancelButton = true
            filter(text: searchText)
            tableView.reloadData()
        }
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !shouldFilter {
            shouldFilter = true
            tableView.reloadData()
            shouldFilter = false
        }
        
        searchBar.resignFirstResponder()
    }
    
    func filter(text : String) {
     
        self.filterNames = self.names.filter({ (name : String) -> Bool in

            let searchMatch = name.range(of: text, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            return searchMatch != nil
        })
        

    }
    
    @IBAction func allowAtt(_ sender: UIButton?) {
        let info = teacher.info!
     
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let today = "\(year)-\(month)-\(day)"
        
                     let dic = ["addTable" : info["main_att_name"], "today" : today,"update":false]
            
            post(postDictionary: dic as NSDictionary, data: nil, url: .addDate) { (data, response, err) in
                if err == nil {
                    let res = response.trimmingCharacters(in: NSCharacterSet.whitespaces)

                    if(res == "success") {
                        showMessage(title: "Great", message: "Now students can take attendance Today", viewController: self, dissappear: false)
                    }else{
                        showMessage(title: "Oops", message: "Something went wrong", viewController: self, dissappear: false)
                    }
                }
            }
    }
}


class Cell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var email: UILabel!
}

class TableViewForTeacherViewingStudents : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var id = "";
    var dates = NSArray()
    var dic = [String:Any]()
    
    @IBAction func backToParent(_ sender: UIButton)
        
    {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        getDates()

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
    
    private func getDates() {

        let postDictionary = ["classMainAtt":dic["main_att_name"] as! String,"classAtt":dic["attendancetable"]!,"id":id,"today":getDate()]
        
        post(postDictionary: postDictionary as NSDictionary, data: nil, url: .getDates) { (data, response, err) in
            if(err == nil) {
                
                let json = convertDataToDictionaryArr(data: data!)
                
                if(json != nil) {
                    self.dates = json!
                    self.tableView.reloadData()
                }else{
                    self.getDates()
                }
            }
        }
        
      
        
    }

    
    
    
}
