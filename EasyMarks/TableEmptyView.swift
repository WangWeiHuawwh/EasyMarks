//
//  TableEmptyView.swift
//  EasyMarks
//
//  Created by hujia on 16/5/16.
//  Copyright © 2016年 wwh. All rights reserved.
//

import UIKit

protocol TableEmptyViewDelegate : class {
    func tableEmptyView(view: TableEmptyView, didClickActionText text: String)
}

class TableEmptyView: UIView {
    
    weak var delegate:TableEmptyViewDelegate?
    
    var tipsLabel: UILabel!
    
    func setupWithTips(tips: String) {
        let font = UIFont.systemFontOfSize(16)
        tipsLabel = UILabel(frame: CGRectMake(0, 15,width, 50))
        tipsLabel.font = font
        tipsLabel.text = tips
        tipsLabel.textColor = UIColor.blackColor()
        tipsLabel.textAlignment = NSTextAlignment.Center
        addSubview(tipsLabel)
        tipsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onClick:"))
        
    }
    
    func onClick(recognizer: UITapGestureRecognizer) {
        delegate?.tableEmptyView(self, didClickActionText: tipsLabel.text ?? "")
    }
}