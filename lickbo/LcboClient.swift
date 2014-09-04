//  LcboClient.swift
//  lickbo
//
//  Created by Stephanie Emila on 2014-09-02.
//  Copyright (c) 2014 Stephanie Emila. All rights reserved.
//

import Foundation

class LcboClient: NSObject {
    let LCBO_API:String = "http://lcboapi.com"
    
    let sessionConfig:NSURLSessionConfiguration?
    let session:NSURLSession?
    
    override init() {
        super.init()
        
        sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig!.allowsCellularAccess = true
        
        session = NSURLSession(configuration: sessionConfig)
    }
    
    func getProducts(product:NSString, completion:((NSArray!) -> Void)!) {
        var encodedProduct:NSString! = product.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        let endpoint:String = "\(LCBO_API)/products?q=\(encodedProduct)"
        
        var productsTask:NSURLSessionTask = session!.dataTaskWithURL(NSURL.URLWithString(endpoint), completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            var httpResp:NSHTTPURLResponse = response as NSHTTPURLResponse
            
            if (error == nil && httpResp.statusCode == 200) {
                
                var jsonError:NSError?
                
                let productsDict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as NSDictionary
                
                if (jsonError == nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(productsDict["result"] as? NSArray);
                    });
                } else {
                    completion(nil);
                }
            } else {
                completion(nil)
            }
        })
        
        productsTask.resume()
    }
}
