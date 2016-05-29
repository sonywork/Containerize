//
//  ContainerInfoViewController.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/26/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//

import UIKit
import CoreData

class ContainerInfoViewController: UITableViewController {
    var container: Container?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UILabel!
    
    @IBOutlet weak var state: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        load()
    }
    
    func load(){
        self.name.text = container?.name
        self.image.text = container?.image
        
        self.state.text = container?.state
    }
}
