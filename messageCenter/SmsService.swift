//
//  SmsService.swift
//  messageCenter
//
//  Created by Eman on 30/3/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import Foundation


class SmsService {
    var settings : Settings!
    
    init() {
        self.settings = Settings()
    }
    
    func getSms(callback: (NSDictionary) -> () ){
        request(settings.viewSms, callback: callback)
    }
    
    func request(url: String, callback: (NSDictionary) ->() ) {
        let nsURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(nsURL, completionHandler: { ( data: NSData?, response: NSURLResponse?, let error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers )
                callback(response as! NSDictionary)
            } catch {
                print("error serializing JSON: \(error)")
            }
            //NSLog("%@", self.employeeData)
        }).resume();
        
    }
    
    func postSmsInUrl( id : String ){        let recordID : String = id
        postInUrl(settings.postSms, recordID: recordID )
    }
    
    func postInUrl( url : String, recordID : String ) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        let postString = "id=" + recordID + "&status=sent"
        print(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
}