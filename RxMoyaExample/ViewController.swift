//
//  ViewController.swift
//  RxMoyaExample
//
//  Created by chendi li on 2017/7/4.
//  Copyright © 2017年 dcubot. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        useAlamofire()
    }
    
    
    
    // 不引入Moya 单独使用封装好的 Alamofire
    func useAlamofire() {
        
        // get请求  根据不同需求，可以在router里 自定义网络请求需要的字段, 业务代码只需要关心传入uid 和 info，然后处理请求到的response
        Alamofire.request(Router.getInfo(uid: "1", token: "abc")).responseJSON { response in
            // 在这里处理 请求到的数据
            debugPrint(response)
        }
        
        // post请求  根据不同需求，可以在router里 自定义网络请求需要的字段, 业务代码只需要关心传入uid 和 info，然后处理请求到的response
        Alamofire.request(Router.postInfo(uid: "1", info: "110")).responseJSON { response in
            // 在这里处理 请求到的数据
            debugPrint(response)
        }
        
        
    }

}

