//
//  HomeViewController.swift
//  SwiftGram
//
//  Created by zeus medina on 3/4/16.
//  Copyright © 2016 Zeus. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import SVProgressHUD

let logoutNotification = "User Logged Out\n"

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var window: UIWindow?
    var storyboard2 = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    var refreshController: UIRefreshControl!
    var data: [PFObject]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        callParseBackend()
        refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshController, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callParseBackend() {
        let query = PFQuery(className: "UserData")
        
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        SVProgressHUD.show()
        
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) ->
            Void in

            if let media = media {
            
                self.data = media
                self.tableView.reloadData()
            
                SVProgressHUD.dismiss()
                
            }
            else {
                if let error = error {
                    NSLog("Error:\(error)")
                }
                
            }
        }

    }
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) ->
            Void in
            
            if let error = error {
            
                NSLog("Error during logout:\n\(error.localizedDescription)")
            }
            else {
                
                NSLog("Logout Success")
                NSNotificationCenter.defaultCenter().postNotificationName(logoutNotification, object: nil)
                

            }
            
        }
        

        
    }
    
    
    // Used to delay
    func delay(delay:Double, closure:()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
    }
    
    // Handles refreshController action
    func onRefresh() {
        delay(2, closure: {
            self.refreshController.endRefreshing()
        })
        
        // Make a call to Parse backend
        callParseBackend()
        
        self.refreshController?.endRefreshing()
    }
    
    
    
    
    //Code below handles filling of tableview data
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (data != nil) {
            return data!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageTableViewCell", forIndexPath: indexPath) as! ImageTableViewCell
        
        if (data?[indexPath.section]["image"] != nil) {
            let imageFile = data?[indexPath.section]["image"] as! PFFile
            
            imageFile.getDataInBackgroundWithBlock({ (theData: NSData?, error: NSError?) ->
                Void in
                
                // Failure to get image
                if let error = error {
                    // Log Failure
                    NSLog("Error loading image at cell \(indexPath.section)")
                }
                    // Success getting image
                else {
                    // Get image and set to cell's content
                    let image = UIImage(data: theData!)
                    cell.dataImageView.image = image
                }
            })

        
        }
        if (data?[indexPath.section]["caption"] != nil) {
            let caption = data![indexPath.section]["caption"] as! String
            cell.captionLabel.text = caption
        }
        
        if (data?[indexPath.section]["author"].username != nil) {
            cell.userLabel.text = data![indexPath.section]["author"].username
        }
        
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
