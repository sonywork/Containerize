//
//  ContainersViewController.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/27/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//

import UIKit
import CoreData

class ContainersViewController: UITableViewController {
    @IBOutlet var table: UITableView!
    @IBOutlet var refresh: UIProgressView!
    
    var selectedContainer: Container?
    
    override func viewDidLoad() {
        DockerClient.sharedInstance().reloadData({ (conf, error) in
            self.refresh.hidden = false
            if error == nil {
                self.table.reloadData()
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let alert = UIAlertController(title: "Error", message: "There was an error loading.", preferredStyle: UIAlertControllerStyle.Alert);
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            self.refresh.hidden = true
        })
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.table.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (DockerClient.sharedInstance().containers?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("con", forIndexPath: indexPath)
        
        cell.textLabel?.text = DockerClient.sharedInstance().containers![indexPath.row].name
        
        return cell
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.refresh.hidden = false
        DockerClient.sharedInstance().reloadData({ (conf, error) in
            if error == nil {
                self.table.reloadData()
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let alert = UIAlertController(title: "Error", message: "There was an error loading.", preferredStyle: UIAlertControllerStyle.Alert);
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            self.refresh.hidden = true
        })
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedContainer = DockerClient.sharedInstance().containers![indexPath.row]
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        self.performSegueWithIdentifier("container_info", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! ContainerInfoViewController
        viewController.container = selectedContainer
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
