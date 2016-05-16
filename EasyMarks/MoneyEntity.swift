//
//  MoneyEntity.swift
//  EasyMarks
//
//  Created by hujia on 16/5/11.
//  Copyright © 2016年 wwh. All rights reserved.
//

import Foundation
import CoreData

@objc(MoneyEntity)
class MoneyEntity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
}
class MoneyModel{
    
    var title: String?
    var detail: String?
    var type: String?
    var money: NSNumber?
    var date: String?
    init(title:String,detail:String,money:Double,type:String,date:String)
    {
        self.title = title
        self.detail = detail
        self.money = money
        self.type = type
        self.date = date
    }
}
