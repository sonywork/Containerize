//
//  Info+CoreDataProperties.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/25/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Info {

    @NSManaged var name: String?
    @NSManaged var root: String?
    @NSManaged var os: String?
    @NSManaged var memTotal: NSNumber?
    @NSManaged var nCPU: NSNumber?
    @NSManaged var version: String?

}
