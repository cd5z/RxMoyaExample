//
//  Rx HandyJSON.swift
//  RxMoyaExample
//
//  Created by chendi li on 2017/7/5.
//  Copyright © 2017年 dcubot. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON
import Moya

fileprivate let RESULT_CODE = "code"
fileprivate let RESULT_MSG = "message"
fileprivate let RESULT_DATA = "data"

public extension Observable {
    func mapResponseToObject<T: HandyJSON>(type: T.Type) -> Observable<T> {
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
                    if let data = data as? Data {
                        
                        let jsonString = String(data: data, encoding: .utf8)
                        // 使用HandyJSON解析成对象
                        let object = JSONDeserializer<T>.deserializeFrom(json: jsonString)
                        if object != nil {
                            return object!
                        }else {
                            throw DCUError.ParseJSONError
                        }
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
    
    func mapResponseToObjectArray<T: HandyJSON>(type: T.Type) -> Observable<[T]> {
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
                    guard let objectsArrays = json[RESULT_DATA] as? NSArray else {
                        throw DCUError.ParseJSONError
                    }
                    // 使用HandyJSON解析成对象数组
                    if let objArray = JSONDeserializer<T>.deserializeModelArrayFrom(array: objectsArrays) {
                        if let objectArray: [T] = objArray as? [T] {
                            return objectArray
                        }else {
                            throw DCUError.ParseJSONError
                        }
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
}
