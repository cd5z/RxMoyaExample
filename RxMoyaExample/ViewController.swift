//
//  ViewController.swift
//  RxMoyaExample
//
//  Created by chendi li on 2017/7/4.
//  Copyright © 2017年 dcubot. All rights reserved.
//

import UIKit
import Alamofire
import Moya
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        useAlamofire()
//        userMoya()
//        mapUser()
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
    
    // 使用Moya进行网络请求
    func userMoya() {
        let provider = MoyaProvider<MyAPI>()
        provider.request(.login(username: "username", password: "password")) { result in
            debugPrint(result)
        }
    }
    
    func userRxMoya() {
        let rxProvider = RxMoyaProvider<MyAPI>()
        rxProvider.request(.login(username: "username", password: "password"))
            .filterSuccessfulStatusCodes()
            .subscribe(onNext: {
                debugPrint($0)
            })
            .addDisposableTo(disposeBag)
        
        rxProvider.request(.login(username: "username", password: "password"))
            .filter(statusCode: 401)
            .subscribe(onNext: {
                debugPrint($0)
            })
            .addDisposableTo(disposeBag)
        
        
        rxProvider.request(.login(username: "username", password: "password"))
            .filter(statusCodes: 200...300)
            .mapJSON()
            .subscribe(onNext: { json in
                debugPrint(json) //已经帮你把response 转成了 JSON，在这里只需要拿到json进行接下来的逻辑就可以了
            })
            .addDisposableTo(disposeBag)
    }
    
    // Moya + RxSwift + ObjectMapper
    func mapUser() {
        //解析成User对象
        let rxProvider = RxMoyaProvider<MyAPI>()
        rxProvider.request(.login(username: "username", password: "password"))
            .mapResponseToObject(type: User.self)
            .subscribe(onNext: { user in
                debugPrint(user)
            })
            .addDisposableTo(disposeBag)
        
        //解析成User对象数组
        rxProvider.request(.login(username: "username", password: "password"))
            .mapResponseToObjectArray(type: User.self)
            .subscribe(onNext: { users in
                debugPrint(users)
            })
            .addDisposableTo(disposeBag)
        
        
    }
    
func handyJSON() {
    //解析成People对象
    let rxProvider = RxMoyaProvider<MyAPI>()
    rxProvider.request(.login(username: "username", password: "password"))
        .mapResponseToObject(type: People.self)
        .subscribe(onNext: { _ in
            
        })
        .addDisposableTo(disposeBag)
    
    //解析成People对象数组
    rxProvider.request(.login(username: "username", password: "password"))
        .mapResponseToObjectArray(type: People.self)
        .subscribe(onNext: { users in
            debugPrint(users)
        })
        .addDisposableTo(disposeBag)
}
}



