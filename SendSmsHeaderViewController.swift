//
//  SendSmsHeader.swift
//  messageCenter
//
//  Created by Eman on 30/3/16.
//  Copyright © 2016 Eman. All rights reserved.
//
import UIKit

class SendSmsHeaderViewController: UITableViewController {
    
    var detailViewController: SendSmsDetailViewController? = nil
    
    var smsCollection = [Sms]()
    
    var service: SmsService!
   
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredNames = [Sms]()
    
    
    func filterContentForSearchText(searchText: String, scope: String = "ALL") {
        filteredNames = smsCollection.filter { sms in
            return sms.name.lowercaseString.containsString(searchText.lowercaseString) }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("insertNewObject:"))
        //self.navigationItem.rightBarButtonItem = addButton
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done:") )
        self.navigationItem.rightBarButtonItem = closeButton
        
            //self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? SendSmsDetailViewController
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        service = SmsService()
        service.getSms {
            (response) in
            self.loadSms(response["employee"] as! NSArray)
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)    }
    
    func loadSms(smses: NSArray) {
        
        for sms in smses {
            let id = Int(sms["sms"]!!["id"]! as! String )
            let name = sms["sms"]!!["name"]! as! String
            let msg = sms["sms"]!!["msg"]! as! String
            let mobile = sms["sms"]!!["mobile"]! as! String
            let senttime = sms["sms"]!!["senttime"]! as! String
            
            let smsObj = Sms(id: id!, name: name, msg: msg, mobile: mobile, senttime: senttime)
            //print(smsObj)
            smsCollection.append(smsObj)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Message" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let sms : Sms
                //let sms = smsCollection[indexPath.row]
                if searchController.active && searchController.searchBar.text != "" {
                    sms = filteredNames[indexPath.row]
                }else{
                    sms = smsCollection[indexPath.row]
                }
                
                let controller = segue.destinationViewController as! SendSmsDetailViewController
                controller.messageDetail = ["msg": sms.msg, "name": sms.name, "mobile": sms.mobile, "id": String(sms.id), "senttime": sms.senttime]
            }
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        smsCollection.removeAll()
        service.getSms {
            (response) in
            self.loadSms(response["employee"] as! NSArray)
        }
        // very important need to add this block for the refresh to work without indexpath.row error
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
        };
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
           return filteredNames.count
        }
        return smsCollection.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        let sms : Sms
        
        if searchController.active && searchController.searchBar.text != "" {
            sms = filteredNames[indexPath.row]
        }else{
            sms = smsCollection[indexPath.row]
        }
        
        cell.textLabel!.text = sms.name
        cell.detailTextLabel!.text = "sent date: " + sms.senttime
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            smsCollection.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

extension SendSmsHeaderViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
