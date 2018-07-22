//
//  Webservices.swift
//  Deveotional
//
//  Created by Kuramsetty Harish on 21/07/18.
//  Copyright © 2018 iDreams. All rights reserved.
//

import UIKit

class Webservices: NSObject {
    
    static let sharedInstance = Webservices()
    
    typealias OnSuccess = (_ data:Data,_ statusCode:Int)->Void
    typealias OnFailure = (_ statusCode:Int)->Void
    
    
    func postApicall(url:String?,params:[String:Any],sucess:@escaping OnSuccess,failure:@escaping OnFailure) -> Void {
        
        var request = URLRequest(url: URL(string: url!)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
           if let receivedData = data {
               sucess(receivedData, 200)
            }else{
                 failure(400)
            }
        })
        
        task.resume()
    }
    
//    func downloadImage(url:String?,success:OnSuccess){
//        URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
//            
//            if error != nil {
//                print(error ?? "error")
//                return
//            }
//            DispatchQueue.main.async(execute: { () -> Void in
//                let image = UIImage(data: data!)
//                self.image = image
//            })
//            
//        }).resume()
//    }
//    }
}
