//
//  MoneyEntity+CoreDataProperties.swift
//  EasyMarks
//
//  Created by hujia on 16/5/12.
//  Copyright © 2016年 wwh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MoneyEntity {

    @NSManaged var detail: String?
    @NSManaged var money: NSNumber?
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var date: String?

}
