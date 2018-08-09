//
//  AppProtocols.swift
//  NYTimes
//
//  Created by Fingent on 08/08/18.
//  Copyright © 2018 fingent. All rights reserved.
//

import UIKit

@objc protocol PresenterDelegate: NSObjectProtocol {
    
    @objc optional func showActivityIndicator(message: String)
    @objc optional func hideActivityIndicator()
    @objc optional func showAlertWithMessage(message:String , title:String ,oktitle:String , cancelTitle:String ,isOkActionHandlingNeeded:Bool)
    @objc optional  func showToastWithMessage(message:String)
    @objc optional func switchToViewWithIdentifier(segueIdentifier:String)
    
}

@objc protocol HomeViewPresenterDelegate: PresenterDelegate{
    @objc optional func didFinishFetchingNewsFeed()

    
}
