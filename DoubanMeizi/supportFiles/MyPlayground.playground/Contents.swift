//: Playground - noun: a place where people can play

import UIKit
import hpple
import Alamofire

var str = "Hello, playground"


Alamofire.request(.GET, "http://www.dbmeinv.com/").responseJSON() {
    
    response in
    
    print(response.request)  // 请求对象
    print(response.response) // 响应对象
    print(response.data)     // 服务端返回的数据
    
    guard let JSON = response.result.value else { return }
    print("JSON: \(JSON)")
    
}

Alamofire.request(.GET, "https://api.500px.com/v1/photos").responseJSON() {
    response in
    
    print(response.request)  // 请求对象
    print(response.response) // 响应对象
    print(response.data)     // 服务端返回的数据
    
    guard let JSON = response.result.value else { return }
    print("JSON: \(JSON)")
}

