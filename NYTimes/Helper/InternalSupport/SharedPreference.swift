//
//  SharedPreference.swift
//  PrecisionTuneAutocare
//
//  Created by Shameerjan on 28/12/17.
//  Copyright © 2017 moi. All rights reserved.
//

import UIKit

class SharedPreference: NSObject {
    final  class var sharedInstance : SharedPreference {
        struct Static {
            static var instance : SharedPreference?
        }
        if !(Static.instance != nil) {
            Static.instance = SharedPreference()
        }
        return Static.instance!
    }
    let window = UIApplication.shared.keyWindow!
    //var sharedServiceStationInfo = ServiceStation()
    var locations:[Location] = []

    var _alertType:String?
    
    
}
