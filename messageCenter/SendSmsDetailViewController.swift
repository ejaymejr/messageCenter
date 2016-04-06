//
//  SendSmsDetailViewController.swift
//  messageCenter
//
//  Created by Eman on 31/3/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit
import MessageUI

class SendSmsDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    

    
    @IBAction func SendButton(sender : AnyObject) {
        
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = showSmsMessage.text!
        messageVC.recipients = [hp_text.text!]
       
        messageVC.messageComposeDelegate = self;
        
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
    
    
    @IBOutlet weak var id_text: UILabel!
    
    @IBOutlet weak var hp_text: UILabel!
    
    @IBOutlet weak var SendButton: UIButton!
    
    @IBOutlet weak var showSmsMessage: UILabel!
    
    var messageDetail = [String : String]()

    override func viewDidLoad() {
        for (key, val) in messageDetail {
            switch(key){
                case "msg":
                    showSmsMessage.text = val
                    break;
                case "name":
                    self.SendButton.setTitle(" Send to: " + val + " ", forState: .Normal)
                    self.SendButton.layer.cornerRadius = 5
                    self.SendButton.layer.borderWidth = 1
                    self.SendButton.layer.borderColor = UIColor.blackColor().CGColor
                    self.SendButton.layer.frame.size.height = 50
                    self.SendButton.layer.backgroundColor = UIColor.blueColor().CGColor
                    self.SendButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    break;
                case "mobile":
                    hp_text.text = val;
                    break;
                case "senttime":
                    break;
                case "id":
                    id_text.text = val;
                    break;
            default:
                break;
            }
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result {
        case MessageComposeResultCancelled:
            NSLog("Cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
            
        case MessageComposeResultFailed:
            NSLog("Failed")
            self.dismissViewControllerAnimated(true, completion: nil)
            
        case MessageComposeResultSent:
            NSLog("Sent")
            let service = SmsService()
            service.postSmsInUrl( id_text.text! )
            self.dismissViewControllerAnimated(true, completion: nil)
            
        default:
            NSLog("Unknown result")
            break
        }
        
    }
    
    

    
}