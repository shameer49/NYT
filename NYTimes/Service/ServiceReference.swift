//
//  ServiceReference.swift
//

import UIKit

@objc protocol ServiceDelegate: NSObjectProtocol {
    func serviceSuccess(_action: Int,_reponseData:Data, _service_status:String, _status_Code:Int, _contentType: String)
    func serviceError(_action: Int,_error_message:String, _service_status:String, _status_Code:Int, _contentType: String)
    @objc optional func authenticationFailure(_action: Int,_error_message:String, _service_status:String, _status_Code:Int, _contentType: String)
    @objc optional func imageDownloadFinished(_ responseData: Data, requestTag: Int)

    @objc optional func AuthenticationFailedHandler()
    @objc optional func didFinishDownloadImage(image: UIImage)
    @objc optional func didFailedDownloadImage(error: String)


}

enum HttpRequestType_Constants : String {
    case POST = "POST"
    case GET = "GET"
}
enum contentType:String{
    case JSON = "application/json"
    case TEXT = "text/plain"
    case URL_ENCODED = "application/x-www-form-urlencoded"
    
}
enum serviceUrl:String{
    case BASE_URL = "http://holidaycarlease.com/mobileapi/"
    //SUB URL
    case GET_NEWS_FEED = "getLogin"

}
enum services:Int{
    case GET_NEWS_FEED  = 1001


}
