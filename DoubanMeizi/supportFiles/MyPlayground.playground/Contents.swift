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


Alamofire.request(.GET, "http://www.dbmeinv.com").responseString {
    
    response in
    
    print(response.request)  // 请求对象
    print(response.response) // 响应对象
    print(response.data)     // 服务端返回的数据
}

Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
    .response { request, response, data, error in
        print(response)
}

Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
    .responseJSON { response in
        print(response.request)  // original URL request
        print(response.response) // URL response
        print(response.data)     // server data
        print(response.result)   // result of response serialization
        
        if let JSON = response.result.value {
            print("JSON: \(JSON)") //具体如何解析json内容可看下方“响应处理”部分
        }
}

Alamofire.request(.GET, "https://httpbin.org/get")
    .responseString { response in
        print(response)
}