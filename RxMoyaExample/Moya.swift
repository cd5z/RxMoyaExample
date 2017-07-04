//
//  Moya.swift
//  RxMoyaExample
//
//  Created by chendi li on 2017/7/4.
//  Copyright © 2017年 dcubot. All rights reserved.
//

import Foundation
import Moya

import Moya


enum MyAPI {
    case login(username: String, password: String)
}



extension MyAPI: TargetType {
    public var task: Task {
        return .request
    }
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    public var baseURL: URL { return URL(string:  "https://baseurl.com/v1")! }
    
    public var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    var parameters: [String: Any]? {
        switch self {
                case .login(let username, let password):
            return ["username" : username, "password" : password]
            
        }
        
    }
    
    public var validate: Bool {
        return true
    }
    public var sampleData: Data {
        return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
    }
}
