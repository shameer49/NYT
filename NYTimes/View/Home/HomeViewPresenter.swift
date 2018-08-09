//
//  HomeViewPresenter.swift
//  NYTimes
//
//  Created by Fingent on 08/08/18.
//  Copyright © 2018 fingent. All rights reserved.
//

import UIKit

class HomeViewPresenter: NSObject,ServiceDelegate,DataPresenterDelegate {
    var presenter                       :DataPresenter!
    var new_service                     :Service!
    private var _requestId              :Int!
    var _params: [String:Any] = [:]
    var delegate:HomeViewPresenterDelegate?
    
    //**-- Init presenter
    func initPresenter(_delegate:HomeViewPresenterDelegate, requestId:Int, params:[String:Any]?){
        delegate = _delegate
        _requestId = requestId
        if let data = params{
            _params = data
            
        }
    }
    
    func serviceSuccess(_action: Int,_reponseData:Data, _service_status:String, _status_Code:Int, _contentType: String){
        self.presenter = DataPresenter()
        self.presenter.initPresenter(_delegate: self, _response: _reponseData, _contentType: _contentType, _action:_action)
        
        self.presenter.serializeData()
    }
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    func serviceError(_action: Int,_error_message:String, _service_status:String, _status_Code:Int, _contentType: String)
    {
        self.delegate?.hideActivityIndicator!()
        self.delegate?.showAlertWithMessage!(message: _error_message, title: "error", oktitle: "ok", cancelTitle: "cancel", isOkActionHandlingNeeded: false)
        //self.delegate?.didFailedWithError(errorMessage: _error_message)
    }

    //MARK:- Data presenter delegate
    func didReceiveServiceResult(responseObject: AnyObject, statusmessage: String, service_status: String, action: Int) {
        manageServiceResponse(requestId: action, response: responseObject)
    }
    
    func didReceiveServiceFailure(responseObject: AnyObject, statusmessage: String, service_status: String, action: Int) {
        print("Failure parsing")
        self.delegate?.hideActivityIndicator!()
    }
    func manageServiceResponse(requestId: Int, response: AnyObject){
        switch requestId {
        case services.GET_NEWS_FEED.rawValue:
            
            let profile = Profile(JSON: response as! [String : Any])
            if let result = response  as? Dictionary<String,Any>{
                self.delegate?.hideActivityIndicator!()
                // print(result)
                self.delegate?.didFinishFetchingProfile!(profile: profile!)
            }
            break
        default:
            break
        }
    }
    
    func execute(){
        if(AppUtilities.isInternetAvailable()){
            self.delegate?.showActivityIndicator!(message: "Signing in")
            let new_Service = getServiceInstance()
            new_Service.delegate(self)
            new_Service.execute()
        }else{
            
            self.delegate?.showAlertWithMessage!(message: "internetError", title: "internetError2", oktitle: "ok", cancelTitle: "cancel", isOkActionHandlingNeeded: false)
        }
    }
    func getServiceInstance()->Service{
        let new_Service = Service()
        switch _requestId! {
            
        case services.GET_NEWS_FEED.rawValue:
            let serviceStationURL = serviceUrl.GET_NEWS_FEED.rawValue
            new_Service.requestType(HttpRequestType_Constants.GET.rawValue)
            let authKey = UserDefaults.standard.object(forKey: "TOKEN") as! String
            new_Service.httpHeader(["Authorization" : "Bearer \(authKey)"])
            new_Service.contentType(contentType.JSON.rawValue)
            new_Service.relativeUrl(serviceStationURL)
            new_Service._requestId(_requestId!)
            break

        default:
            break
        }
        
        return new_Service
    }
    
}
