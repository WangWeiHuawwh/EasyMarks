//
//  MoneyDetail.swift
//  EasyMarks
//
//  Created by hujia on 16/5/11.
//  Copyright © 2016年 wwh. All rights reserved.
//

import UIKit
class MoneyDeatil: NSObject {
    var title: String?
    var moneyModel:MoneyModel!
    var texts: String?
    var date: String?
    var everyRowHeight: [CGFloat] = []
    var cellHeight: CGFloat = 20
    init(moneyModel:MoneyModel) {
        self.moneyModel = moneyModel
        self.title = moneyModel.title
        self.texts = moneyModel.detail
        self.date = moneyModel.date
    }

}