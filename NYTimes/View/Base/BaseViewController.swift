//
//  BaseViewController.swift
//  NYTimes
//
//  Created by Fingent on 08/08/18.
//  Copyright © 2018 fingent. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- PRESENTER DELEGATE METHODS
    func showActivityIndicator(message: String) {
        //self.view.makeToastActivity(.center)
    }
    func hideActivityIndicator() {
        //self.view.hideToastActivity()
    }
    func showToastWithMessage(message: String) {
        //Show Toast message if needed
        //self.view.makeToast(message, duration: 2.0, position: .bottom)
    }
    func showAlertWithMessage(message: String, title: String, oktitle: String, cancelTitle: String, isOkActionHandlingNeeded: Bool) {
        
        
    }
}
