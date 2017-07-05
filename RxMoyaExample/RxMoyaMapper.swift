//
//  RxMoyaMapper.swift
//  RxMoyaExample
//
//  Created by chendi li on 2017/7/4.
//  Copyright © 2017年 dcubot. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Moya
enum DCUError : Swift.Error {
    // 解析失败
    case ParseJSONError
    // 网络请求发生错误
    case RequestFailed
    // 接收到的返回没有data
    case NoResponse
    //服务器返回了一个错误代码
    case UnexpectedResult(resultCode: Int?, resultMsg: String?)
}

enum RequestStatus: Int {
    case requestSuccess = 200
    case requestError
}

let RESULT_CODE = "code"
let RESULT_MSG = "message"
let RESULT_DATA = "data"
public extension Observable {
    func mapResponseToObject<T: BaseMappable>(type: T.Type) -> Observable<T> {
        return map { response in
            
            // 得到response
            guard let response = response as? Moya.Response else {
                throw DCUError.NoResponse
            }
            
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                throw DCUError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw DCUError.NoResponse
            }
            
            // 服务器返回code
            if let code = json[RESULT_CODE] as? Int {
                if code == RequestStatus.requestSuccess.rawValue {
                    // get data
                    let data =  json[RESULT_DATA]
                    if let data = data as? [String: Any] {
                        // 使用 ObjectMapper 解析成对象
                        let object = Mapper<T>().map(JSON: data)!
                        return object
                    }else {
                        throw DCUError.ParseJSONError
                    }
                } else {
                    throw DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: json[RESULT_MSG] as? String)
                }
            } else {
                throw DCUError.ParseJSONError
            }
            
        }
    }
    
    func mapResponseToObjectArray<T: BaseMappable>(type: T.Type) -> Observable<[T]> {
        return map { response in
            
            // 得到response
            guard let response = response as? Moya.Response else {
                throw DCUError.NoResponse
            }
            
            // 检查状态码
            guard ((200...209) ~= response.statusCode) else {
                throw DCUError.RequestFailed
            }

            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw DCUError.NoResponse
            }
            
            // 服务器返回code
            if let code = json[RESULT_CODE] as? Int {
                if code == RequestStatus.requestSuccess.rawValue {
                    // 对象数组
                    var objects = [T]()
                    guard let objectsArrays = json[RESULT_DATA] as? [Any] else {
                        throw DCUError.ParseJSONError
                    }
                    for object in objectsArrays {
                        if let data = object as? [String: Any] {
                            // 使用 ObjectMapper 解析成对象
                            let object = Mapper<T>().map(JSON: data)!
                            // 将对象添加到数组
                            objects.append(object)
                        }
                    }
                    return objects

                } else {
                    throw DCUError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: json[RESULT_MSG] as? String)

                }
            } else {
                throw DCUError.ParseJSONError
            }
        }
    }
}
