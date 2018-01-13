//
//  NetworkManager.swift
//  Astro
//
//  Created by Michael Abadi on 11/1/17.
//  Copyright © 2017 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import Alamofire

/**
 * @discussion Enum for the NetworkError
 */
public enum NetworkError: Error {
    case dataIsNotEncodable(_: Any)
    case badRequest(_: String)
    case unauthorized(_: String)
    case forbidden(_: String)
    case serverError
    case httpMethodNotAllow
    case stringFailedToDecode(_: Data, encoding: String.Encoding)
    case invalidURL(_: String)
    case missingEndpoint
}

// Define the parameter's dictionary
public typealias ParametersDict = [String : Any]

// Define the header's dictionary
public typealias HeadersDict = [String: String]

/**
 * @discussion Define what kind of HTTP method must be used to carry out the `Request`
 * @case get
 * @case post
 * @case put
 * @case delete
 * @case patch
 */
public enum RequestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum RequestPath {
    case getChannelList
    case getCurrentAiringTime
}

public enum TypeObject {
    case channelList
    case guideList
}

/**
 * @discussion Class for Network Manager services
 */
class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    
    func fetchUrl(request: RequestPath, body: ParametersDict?, headers: HeadersDict?, _ completion: @escaping (AnyObject) -> ()){
        switch request {
        case .getChannelList:
            //fetchFeedForUrlString(Config.EndpointV3.getChannelList, type: .channelList, completion: completion)
            requestEndpoint(Config.EndpointV3.getChannelList, type: .channelList, method: .get, body: nil, headers: nil, completion: completion)
        case .getCurrentAiringTime:
            requestEndpoint(Config.EndpointV3.getEvents, type: .guideList, method: .get, body: body, headers: nil, completion: completion)
        }
    }
    
    /**
     * @discussion Function for fetching URL Request using Alamofire
     * @param urlString - the url
     * @param type - the type of the object or model
     * @param method - http method
     * @param body - http body
     * @param headers - http header
     */
    func requestEndpoint(_ urlString: String, type: TypeObject, method: HTTPMethod, body: ParametersDict?, headers: HeadersDict?, completion: @escaping (AnyObject) -> ()) {
        
        //let parameters: Parameters = body
        let utilityQueue = DispatchQueue.global(qos: .utility)

        if let body = body {
            switch method {
            case .get:
                let param: Parameters = body as Parameters
                Alamofire.request(urlString, parameters: param).responseJSON(queue: utilityQueue) { response in
                    switch type {
                    case .guideList:
                        let objectResponse = response.map { json -> GuideChannelList in
                            return GuideChannelList(dictionary: json as! [String : AnyObject])
                        }
                        
                        if let object = objectResponse.value {
                            print("Response: { code: \(object.responseCode), message: \(object.responseMessage) }")
                            if object.responseCode == "200" {
                                DispatchQueue.main.async(execute: {
                                    completion(object as AnyObject)
                                })
                            }
                        }
                    default: break
                    }
                }
            default:
                break
            }
        }else{
            Alamofire.request(urlString, method: method)
                .responseJSON(queue: utilityQueue) { response in
                    
                    switch type {
                        case .channelList :
                            let objectResponse = response.map { json -> ChannelList in
                                return ChannelList(dictionary: json as! [String : AnyObject])
                            }
                            
                            if let object = objectResponse.value {
                                print("Response: { code: \(object.responseCode), message: \(object.responseMessage) }")
                                if object.responseCode == "200" {
                                    DispatchQueue.main.async(execute: {
                                        completion(object as AnyObject)
                                    })
                                }
                            }
                        default:
                            break
                    }
            }
        }
        
    }
    
}

