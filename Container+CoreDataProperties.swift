//
//  Container+CoreDataProperties.swift
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

extension Container {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var image: String?
    @NSManaged var state: String?

}
