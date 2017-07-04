//
//  Router.swift
//  RxMoyaExample
//
//  Created by chendi li on 2017/7/4.
//  Copyright © 2017年 dcubot. All rights reserved.
//

import UIKit
import Alamofire

public enum Router: URLRequestConvertible {
    static let baseURLPath = "http://example.com/v1"
    
    // 假设一个get请求，只需要传 uid  和 token
    case getInfo(uid: String, token: String)
    
    // 假设一个post请求，只需要传 uid  和 info
    case postInfo(uid: String, info: String)
    
    var method: HTTPMethod {
        switch self {
        case .getInfo:
            return .get
        case .postInfo:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getInfo:
            return "/getInfo"
        case .postInfo:
            return "/postInfo"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .getInfo(let uid, let token):
                return ["uid": uid, "token" : token]
            case .postInfo(let uid, let info):
                return ["uid": uid, "info": info]
            default:
                return [:]
            }
        }()
        
        let url = try Router.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
