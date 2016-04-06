//
//  Sms.swift
//  messageCenter
//
//  Created by Eman on 30/3/16.
//  Copyright © 2016 Eman. All rights reserved.
//
import Foundation

class Sms {
    var id: Int
    var name: String
    var msg: String
    var mobile: String
    var senttime: String
    
    init (id : Int, name : String, msg: String, mobile: String, senttime: String) {
        self.id = id
        self.name = name
        self.msg = msg
        self.mobile = mobile
        self.senttime = senttime
    }
    
    
    
    func toJSON() -> String {
        return "{\"Post\":{\"id\":\(id),\"title\":\"\(name)\",\"author\":\"\(msg)\",\"content\":\"\(mobile)\"}}"
    }
    
    
}