//
//  AppUtilities.swift
//  PrecisionTuneAutocare
//
//  Created by Shameerjan on 20/12/17.
//  Copyright © 2017 moi. All rights reserved.
//

import UIKit
import SystemConfiguration

class AppUtilities: NSObject {
    class func isInternetAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    class func showActivityIndicatory(_ uiView: UIView, msg : String) {
        
        DispatchQueue.main.async {
            uiView.isUserInteractionEnabled = false
       
            let strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 270, height: 50))
            strLabel.font = strLabel.font.withSize(12)
            strLabel.text = "Loading"//msg
            strLabel.textColor = UIColor.white
            
            
            let messageFrame = UIView(frame: CGRect(x: uiView.frame.midX , y: uiView.frame.midY - 111 , width: 130, height: 50))
            messageFrame.center = CGPoint(x: uiView.bounds.midX,
                                          y: uiView.bounds.midY);
            //messageFrame.center = uiView.center
            messageFrame.layer.cornerRadius = 15
            messageFrame.backgroundColor  = themeRed

            messageFrame.alpha = 0.7
            
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
            messageFrame.tag=101
            
            messageFrame.addSubview(strLabel)
           // uiView.addSubview(messageFrame)
            SharedPreference.sharedInstance.window.addSubview(messageFrame)


            
        }
    }
    class func removeActivityIndicator(_ uiView : UIView)->Void{
        DispatchQueue.main.async {
            uiView.isUserInteractionEnabled = true

            if let viewBg : UIView = SharedPreference.sharedInstance.window.viewWithTag(101)
            {
                viewBg.removeFromSuperview()
                
            }
        }
    }
    func getFromJson(jsonFileName:String)->[AnyObject]{
        
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [AnyObject] {
                    // do stuff
                    print(jsonResult)
                    return jsonResult
                }
            } catch {
                // handle error
            }
        }
        return []
    }

    class func getUniqeId()->Int{
    
        return  Int(NSDate().timeIntervalSince1970)
    }
    class  func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    class func getDeviceType()->String{
        
        // 1. request an UITraitCollection instance
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
//        switch (deviceIdiom) {
//
//        case .pad:
//            print("iPad style UI")
//            return devices.ipad.rawValue
//        case .phone:
//            print("iPhone and iPod touch style UI")
//            return devices.iphone.rawValue
//
//
//        default:
//            print("Unspecified UI idiom")
//            return devices.other.rawValue
//
//        }
        return ""
    }
    class func getBase64StringOfImage(image: UIImage)->String{
        
        if let imageData = image.jpeg(.lowest) {
            print(imageData.count)
            
            //let imageData: NSData = UIImageJPEGRepresentation(image, 1.0)! as NSData;
            
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            let dataUri = "data:image/jpeg;base64,\(strBase64)"
            return dataUri
        }
        return ""
    }
}
