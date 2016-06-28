//
//  InfoViewController.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/26/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: UITableViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var cpu: UILabel!
    @IBOutlet weak var mem: UILabel!
    @IBOutlet weak var os: UILabel!
    @IBOutlet weak var root: UILabel!
    
    @IBOutlet var refresh: UIProgressView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reload()
    }
    
    func reload(){
        self.name.text = DockerClient.sharedInstance().info?.name
        self.version.text = DockerClient.sharedInstance().info?.version
        self.cpu.text = DockerClient.sharedInstance().info?.nCPU?.stringValue
        self.mem.text = DockerClient.sharedInstance().info?.memTotal?.stringValue
        self.os.text = DockerClient.sharedInstance().info?.os
        self.root.text = DockerClient.sharedInstance().info?.root
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.refresh.hidden = false
        DockerClient.sharedInstance().reloadData({ (conf, error) in
            if error == nil {
                self.reload()
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

    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}

