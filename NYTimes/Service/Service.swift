//
//  Service.swift
//



import Foundation
import UIKit

private var _baseUrl                       : String = serviceUrl.BASE_URL.rawValue
private var _relativeUrl                   : String = ""
private var _serviceUrl                    : String = ""
private var _params                        :Data?
private var _statusCode                    :Int = 0
private var _httpStatusCode                :Int?
private var _serviceResult                 :NSDictionary?
private var _httpAdditionalHeader          :Dictionary<String, Any>?
var _requestType                           :String!
var _contentType                           :String!
private var _httpHeader:Dictionary<String, String>?


open class Service :NSObject,URLSessionDelegate  {
    
    var _delegate:ServiceDelegate? = nil
    private var requestId:Int?
    var task:URLSessionDataTask!
    
    open class var baseUrl: String
        {
        get { return _baseUrl }
        set { _baseUrl = newValue }
    }
    
    open func setUrl(_ baseUrl:String , relativeUrl : String) {
        _relativeUrl = relativeUrl
        _serviceUrl = baseUrl + _relativeUrl
    }
    open func relativeUrl(_ value:String) {
        _relativeUrl = value
        _serviceUrl = _baseUrl + _relativeUrl
    }
    open func staticUrl(_ value:String) {
        _serviceUrl = value
    }

    open func params(_ value:Data) {
        _params=value
    }
    open func _requestId(_ value:Int) {
        requestId = value
    }
    open func requestType(_ value:String) {
        _requestType = value
    }
    open func contentType(_ value:String) {
        _contentType = value
    }
    open func httpHeader(_ value:Dictionary<String, String>) {
        _httpHeader = value
    }
    open func delegate(_ value:NSObjectProtocol) {
        _delegate = value as? ServiceDelegate
    }
    
    
    func execute() {
       // print(_serviceUrl)
        guard let session_url = URL(string: _serviceUrl) else {
            print("Error: Unable to  create URL")
            return
        }
        
        // set up the session
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        
        if _httpHeader != nil {
            configuration.httpAdditionalHeaders = _httpHeader
        }
        
        var request = URLRequest(url: session_url)
        print(session_url)
        request.httpMethod = _requestType
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let session = URLSession(configuration : configuration)
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        //        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        if(_requestType == HttpRequestType_Constants.POST.rawValue){
            if _params != nil {
                request.httpBody = _params
            }
        }
        
        //**-- Create  Data task and Initiate the Request
        
        task = session.dataTask(with: request) {
            (data, response, error) in
            
            //**--  Check for  Errors
            guard error == nil else {
                print("ErrorOccured : \(error)")
                DispatchQueue.main.async {
                    self._delegate?.serviceError(_action: self.requestId!, _error_message: "internetError3", _service_status: "error", _status_Code: 0, _contentType: _contentType)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code \(httpResponse.statusCode)")
                _httpStatusCode = httpResponse.statusCode
                print("Status error \(httpResponse.description)")
            }
            
            //**-- Make sure Data is recieved
            guard let responseData = data else {
                print("Error:No Data Recieved")
                DispatchQueue.main.async {
                    self._delegate?.serviceError(_action: self.requestId!, _error_message: "No Data recieved from server", _service_status: "error", _status_Code: 0, _contentType: _contentType)
                }
                return
            }
            
            //**-- Send reponse data to serialize according to response type
            if _httpStatusCode == 200 || _httpStatusCode == 201{
                print(self.requestId!)
                self._delegate?.serviceSuccess(_action: self.requestId!, _reponseData: responseData, _service_status: "success", _status_Code: 1, _contentType: _contentType)
            }else if _httpStatusCode == 401{
                // Autentication failuire
                self._delegate?.authenticationFailure!(_action: self.requestId!,_error_message:"Authentication went wrong", _service_status:"Failure", _status_Code:0, _contentType: _contentType)
            }else{
                // other error
                 var errorMessage = ""
                if let returnData = String(data: data!, encoding: .utf8) {
                     let responseDict = self.convertToDictionary(text: returnData)
                    print(responseDict)
                    if let errorDict  = responseDict?["error"] as? [String:Any]{
                        errorMessage = (errorDict["description"] as? String)!
                    }
                    
                }
                
                if let _ = _contentType{
                      self._delegate?.serviceError(_action: self.requestId!,_error_message:errorMessage, _service_status:"failure", _status_Code:_httpStatusCode!, _contentType: _contentType)
                    
                }else{
                    self._delegate?.serviceError(_action: self.requestId!,_error_message:errorMessage, _service_status:"failure", _status_Code:_httpStatusCode!, _contentType: "application/json")
                }
              
            }
        }
        task.resume()
        
    }
    func downloadImage(catPictureURL: String){
        let session = URLSession(configuration: .default)
        let URL_IMAGE = URL(string: catPictureURL)

        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        //displaying the image
                        DispatchQueue.main.async {
                            
                           // self.uiImageView.image = image
                            self._delegate?.didFinishDownloadImage!(image: image!)
                        }
                    } else {
                        print("Image file is currupted")
                        self._delegate?.didFailedDownloadImage!(error: "internetError3")
                    }
                } else {
                    self._delegate?.didFailedDownloadImage!(error: "internetError3")
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()

    }
    // get an image from server
    func getImage(_ imageURL: String, requestTag: Int) {
        print(imageURL)
        let imageRequest = NSMutableURLRequest(url: URL(string: imageURL)!)
        let task = URLSession.shared.dataTask(with: imageRequest as URLRequest, completionHandler: { responseData, response, responseError in
            if response != nil {
                let responseStatusCode = (response as! HTTPURLResponse).statusCode
                if responseData?.count == 0 {
                }
                else if responseStatusCode == 200 {
                    if let image = responseData{
                        self._delegate?.imageDownloadFinished!(responseData!, requestTag: requestTag)

                    }
                }
                else {
                }
            }
            else if responseError != nil {
            }
            else {
                //self._delegate?.requestFinished(responseData!, requestTag: requestTag)
            }
        })
        task.resume()
    }
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("didBecomeInvalidWithError: \(error)")
    }
    
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        completionHandler(
            .useCredential,
            URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("URLSessionDidFinishEventsForBackgroundURLSession: \(session)")
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
