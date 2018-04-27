//
//  TeacherViewController.swift
//  SignIn
//
//  Created by Pc on 12/17/16.
//  Copyright © 2016 pc. All rights reserved.
//

import UIKit

class TeacherViewController: UIPageViewController {

    private(set) lazy var orderedViewControllers : [UIViewController] = {
        
        return [self.newViewController(id: "Welcome"),self.newViewController(id: "Location")];
        
    

    }()
    
    private func newViewController (id : String) -> UIViewController {
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        dataSource = self
        
        if let firstViewContoller = orderedViewControllers.first {
            setViewControllers([firstViewContoller], direction: .forward, animated: true, completion: nil)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TeacherViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else{
            return nil
        }
    
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else{
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else{
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    
    
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}
