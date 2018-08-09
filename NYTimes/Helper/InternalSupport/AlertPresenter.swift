//
//  AlertPresenter.swift
//  RentmojiResident
//
//  Created by FTS-MAC-017 on 23/11/16.
//  Copyright © 2016 Fingent Technology Solutions. All rights reserved.
//

import Foundation
import UIKit

class AlertPresenter: NSObject {
    

    public static func showshowAlertOnVC (viewController: UIViewController,
                             title: String, message: String,
                             okTitle: String,cancelTitle:String,
                             async: Bool = true,
                             onOK handler: ((UIAlertAction) -> Void)? = nil) {//  If Cancel Action is not needed Pass an empty String for 'cancelTitle'
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: okTitle,
                                     style: UIAlertActionStyle.default, handler: handler)
        alertController.addAction(okAction)
        
        if cancelTitle != "" {//Check if Cancel Action is needed then add Cancel Action
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                print("Cancel")
                 alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
        }
        
        if (async) {
            DispatchQueue.main.async{
                viewController.present(alertController, animated: true,
                                         completion: nil
                )
            }
        } else {
            DispatchQueue.main.sync() {
                viewController.present(alertController, animated: true,
                                         completion: nil)
            }
        }
        
    }

}
