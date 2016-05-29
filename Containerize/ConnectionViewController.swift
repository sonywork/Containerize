//
//  ConnectionViewController.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/25/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Populate Last Server in Textbox
        let addr = NSUserDefaults.standardUserDefaults().valueForKey("serverAddr")
        
        if addr != nil {
            serverAddr.text = addr as? String
        }
    }
    
    @IBOutlet weak var serverAddr: UITextField!
    
    @IBAction func connect(sender: AnyObject) {
        if NSUserDefaults.standardUserDefaults().valueForKey("serverAddr") != nil &&  NSUserDefaults.standardUserDefaults().valueForKey("serverAddr") as! String == self.serverAddr.text! {
            // Prefetches data prior to load if reconnecting to last server:
            // - Otherwise current data will not be shown and dumped from CoreData.
            // - This is so that the application does not consume too much storage since
            //   a cluster could run 100s to 1000s of mini containers
            DockerClient.sharedInstance().fetchData({ (error) in
                // if there is an error prefetching data, leave it, and load data from API and error then.
                self.performSegueWithIdentifier("connect", sender: self)
                UIApplication.sharedApplication().statusBarStyle = .Default
                
                DockerClient.sharedInstance().config(self.serverAddr.text!) { (conf, error) in
                    // configure client with IP addr, and attempt to prefetch data, silently fail if error;
                    //  loads data on view
                }
            })
        } else {
            DockerClient.sharedInstance().config(serverAddr.text!) { (conf, error) in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    if conf == 1{
                        // Segue and change Status Bar Style for Light Background.
                        self.performSegueWithIdentifier("connect", sender: self)
                        UIApplication.sharedApplication().statusBarStyle = .Default
                        // Store Last Server Addr.
                        NSUserDefaults.standardUserDefaults().setValue(self.serverAddr.text!, forKey: "serverAddr")
                    } else if error != nil{
                        // Show Error Message.
                        let alert = UIAlertController(title: "Error", message: "There was an error loading.", preferredStyle: UIAlertControllerStyle.Alert);
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
