//
//  DbManager.swift
//  EasyMarks
//
//  Created by hujia on 16/5/11.
//  Copyright © 2016年 wwh. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class DbManager: NSObject {
    var app:AppDelegate!
    var context:NSManagedObjectContext!
    override init() {
        app = UIApplication.sharedApplication().delegate as! AppDelegate
        context = app.managedObjectContext
    }
    func addMonyEntity(moneyEntitys:Array<MoneyModel>){
        for moneyEntity in moneyEntitys {
            let newItem: MoneyEntity = NSEntityDescription.insertNewObjectForEntityForName("MoneyEntity", inManagedObjectContext: context) as! MoneyEntity
            newItem.title = moneyEntity.title
            newItem.money = moneyEntity.money
            newItem.detail = moneyEntity.detail
            newItem.type = moneyEntity.type
            newItem.date = moneyEntity.date
        }
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    func addMonyEntityOne(moneyEntity:MoneyModel){
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("MoneyEntity", inManagedObjectContext: context) as! MoneyEntity
        newItem.title = moneyEntity.title
        newItem.money = moneyEntity.money
        newItem.detail = moneyEntity.detail
        newItem.type = moneyEntity.type
        newItem.date = moneyEntity.date
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    func getMoneyEntity() -> Array<MoneyModel>{
        var error: NSError? = nil
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "MoneyEntity")
        //fReq.predicate = NSPredicate(format:"name CONTAINS 'B' ")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "date" , ascending: false)
        fReq.sortDescriptors = [sorter]
        
        fReq.returnsObjectsAsFaults = false
        
        var result: [AnyObject]?
        do {
            result = try context.executeFetchRequest(fReq)
        } catch let nserror1 as NSError{
            error = nserror1
            result = nil
        }
        var moneyEntitys = Array<MoneyModel>()
        for resultItem in result! {
            let moneyItem = resultItem as! MoneyEntity
            moneyEntitys.append(MoneyModel(title:moneyItem.title ?? "",detail:moneyItem.detail ?? "",money:Double(moneyItem.money ?? 0),type:moneyItem.type ?? "",date:moneyItem.date
                ?? ""))
        }
        return moneyEntitys
    }
}