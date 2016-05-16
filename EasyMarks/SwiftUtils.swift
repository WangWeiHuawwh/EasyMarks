//
//  SwiftUtils.swift
//  EasyMarks
//
//  Created by hujia on 16/5/11.
//  Copyright © 2016年 wwh. All rights reserved.
//

import Foundation
import UIKit
//appCore:所有全局相关由它掌管
func getDbManager() -> DbManager {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    return delegate.dbManager
}
func getTimeNow() -> String {
    let date = NSDate()
    let timeFormatter = NSDateFormatter()
    timeFormatter.dateFormat = "yyy-MM-dd HH:mm"
    let strNowTime = timeFormatter.stringFromDate(date) as String
    return strNowTime
}
func screenWidth() -> CGFloat {
    return UIScreen.mainScreen().bounds.size.width
}

func screenHeight() -> CGFloat {
    return UIScreen.mainScreen().bounds.size.height
}
func ios5() -> Bool {
    return (UIDevice.currentDevice().systemVersion as NSString).doubleValue < 5.0
}

func ios6() -> Bool {
    return !ios7() && (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 6.0
}

func ios7() -> Bool {
    return !ios8AndLater() && (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 7.0
}

func ios8AndLater() -> Bool {
    return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0
}

func iphone5() -> Bool {
    return UIScreen.mainScreen().bounds.size.height == 568
}

func iphone6() -> Bool {
    return UIScreen.mainScreen().bounds.size.height == 667
}

func iphone6p() -> Bool {
    return UIScreen.mainScreen().bounds.size.height == 736
}

func iphone4() -> Bool {
    return UIScreen.mainScreen().bounds.size.height == 480
}