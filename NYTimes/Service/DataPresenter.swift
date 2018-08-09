//
//  DataPresenter.swift
//
//

import UIKit

@objc protocol DataPresenterDelegate {
    @objc optional func didReceiveServiceResult(responseObject:AnyObject, statusmessage: String, service_status: String, action:Int)
    @objc optional func didReceiveServiceFailure(responseObject:AnyObject, statusmessage: String, service_status: String, action:Int)
}

class DataPresenter: NSObject {
    weak private var delegate                  :DataPresenterDelegate?
    private var _responseData                  :Data = Data()
    private var _contentType                   :String = ""
    private var _requestId                     :Int?
    private var _serviceResult                 :NSDictionary?
    
    //**-- Init presenter
    func initPresenter(_delegate:DataPresenterDelegate, _response: Data, _contentType:String, _action:Int){
        delegate = _delegate
        self._responseData      = _response
        self._contentType       = _contentType
        self._requestId         = _action
    }
    func serializeData(){
        switch _contentType {
        case contentType.URL_ENCODED.rawValue:
            urlEnodedSerialization()
        default:
            jsonSerialization()
        }
    }
    func jsonSerialization(){
        //**-- Try to Serialize (Convert) Data to JSON
        do {
//            print("Trying to Serialize Recieved Data")
            print(_responseData)
//            print("Response data ==> \(String(describing: String(data: _responseData, encoding: String.Encoding.utf8)))")
            // print("HTTPURLResponse data ==> \(_responseData as! HTTPURLResponse)")
            let JSON = try JSONSerialization.jsonObject(with: _responseData, options: JSONSerialization.ReadingOptions(rawValue: 0))
            guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                
                DispatchQueue.main.async {
                    self.delegate?.didReceiveServiceFailure!(responseObject: self._responseData as AnyObject, statusmessage: "Response data format is invalid", service_status: "Error", action: self._requestId!)
                }
                print("Error : Recieved Data is not a JSON dictionary")
                return
            }
            
            print("Response String : " + JSONDictionary.description)
            _serviceResult = JSONDictionary as NSDictionary?
            //**-- Parse Serialized Data
            
            var responseObject:AnyObject?
            var errorObject:AnyObject?
            if  let _result      = _serviceResult!["data"]  as?  NSDictionary { responseObject = _result }
            if  let _result      = _serviceResult!["data"]  as?  NSArray { responseObject = _result }
            if  let _errorResult = _serviceResult!["error"] as? NSDictionary { errorObject = _errorResult }
            
            var status = "defaultStatus"
            if let _status = _serviceResult!["status"] as? String { status = _status }
            var message:String? = "Service Message"
            if let _message =  (_serviceResult!["message"] as? String) { message = _message}
            var statusCode = 0
            if let  _sCode = (_serviceResult!["code"] as? NSNumber) {  statusCode = Int(_sCode)}
            
            //**-- Check if  Error Data is recieved
            if let _ = errorObject {
                if let  _status   =   errorObject!["status"]      as? String { status = _status }
                if let  _sCode    =   errorObject!["statusCode"]  as? NSNumber {  statusCode = Int(_sCode)}
                message           =   "Service Error with Status Code :\(statusCode)"
            }
            //** Temporary settings
            status = "success"
            if status == "success"
            {
                let displayMessage = message ?? status
                DispatchQueue.main.async {
                   // print(responseObject!)
                    //** Temporary call
                    self.delegate?.didReceiveServiceResult!(responseObject: self._serviceResult!, statusmessage: displayMessage, service_status: "Success", action: self._requestId!)
                }
            }
            else {
                DispatchQueue.main.async {
                    if(statusCode == 401) {
                        print("401 STATUS CODE - Do Auto Sign Out")
                    }
                    self.delegate?.didReceiveServiceFailure!(responseObject: self._responseData as AnyObject, statusmessage: message!, service_status: "Error", action: self._requestId!)
                }
            }
        }
        catch  {
            DispatchQueue.main.async {
                self.delegate?.didReceiveServiceFailure!(responseObject: self._responseData as AnyObject, statusmessage: "error trying to convert data to JSON", service_status: "Error", action: self._requestId!)
            }
            print("error trying to convert data to JSON")
            return
        }
    }
    func urlEnodedSerialization(){
        let _responseString = String(data: _responseData, encoding: String.Encoding.utf8) as String!
        print("Reponse String ----> \(String(describing: _responseString))")
        self.delegate?.didReceiveServiceResult!(responseObject: _responseString! as AnyObject, statusmessage: "Success", service_status: "Success", action: self._requestId!)
    }
}
