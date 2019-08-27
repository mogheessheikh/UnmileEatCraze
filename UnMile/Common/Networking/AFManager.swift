//
//  AlamofireManager.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/5/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AFManager {
    
    static let shared = AFManager()
    //private static let baseURL = ServerURLs.devURL
    private let isDebug = true

    func requestURL(_ strURL: String, httpMethod: HTTPMethod, params: [String : Any]?, headers: [String: String]? = nil, encoding: ParameterEncoding = URLEncoding(), success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
        
        printParameters(params)
        
        let completeURL = strURL

        Alamofire.request(completeURL, method: httpMethod, parameters: params, encoding: encoding, headers: headers) .responseJSON {
            (responseObject) -> Void in
            
//            self.debug(response: responseObject)

            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                self.printResponse(resJson)
                let errorExists = resJson["error"].exists()
                success(resJson, errorExists)
                return
            }
            
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                self.printError(error)
                failure(error)
                return
            }
        }
    }
    
//    func requestFileDownload(_ strURL: String, httpMethod: HTTPMethod, params: [String : Any]?, headers: [String: String]? = nil, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//        
//        printParameters(params)
//        
//        let completeURL = AFManager.baseURL + strURL
//        
//        Alamofire.download(completeURL, method: httpMethod, parameters: params, encoding: URLEncoding(), headers: headers, to: DownloadRequest.suggestedDownloadDestination()) .responseString {
//            (responseObject) -> Void in
//            
////            print("\nresponseString \n \(responseObject)")
//            
//            if responseObject.result.isSuccess {
//                let resJson = JSON(responseObject.result.value!)
////                self.printResponse(resJson)
//                let errorExists = resJson["error"].exists()
//                success(resJson, errorExists)
//                return
//            }
//            
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                self.printError(error)
//                failure(error)
//                return
//            }
//            
//        }
//        
//    }
    
    fileprivate func printParameters(_ params: [String : Any]?) {
        if isDebug {
            if let parameters = params {
                if let theJSONData = try? JSONSerialization.data(withJSONObject: parameters, options: []), let theJSONText = String(data: theJSONData, encoding: .utf8) {
                    print("Parameters: \(theJSONText)")
                } else {
                    debugPrint("Parameters: ", JSON(parameters))
                }
            }
        }
    }
    
    fileprivate func printResponse(_ resJson: JSON) {
        if self.isDebug {
            debugPrint("Response: ", resJson)
        }
    }
    
    fileprivate func printError(_ error: Error) {
        if self.isDebug {
            debugPrint("Error: ", error.localizedDescription)
        }
    }
    
    private func debug(response: DataResponse<Any>) {
        
        if isDebug {
            
            debugPrint("Request: ", response.request!)  // original URL request
            debugPrint("Response: ", response.response!) // URL response
            debugPrint("Data: ", response.data!)     // server data
            debugPrint("Result: ", response.result)   // result of response serialization
            debugPrint("Response Value: ", response.value!) // original Response
            
            guard let httpBody = response.request?.httpBody else { return }
            
            do {
                let jsonParams = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)
                debugPrint(jsonParams)
            } catch {
                print(error)
            }
        }
    }
}
