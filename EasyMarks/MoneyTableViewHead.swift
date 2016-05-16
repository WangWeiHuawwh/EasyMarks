//
//  MoneyTableViewCell.swift
//  EasyMarks
//
//  Created by hujia on 16/5/11.
//  Copyright © 2016年 wwh. All rights reserved.
//

import UIKit

class MoneyTableViewHead: UITableViewHeaderFooterView {
    
    var questionLabel: UILabel?
    var arrowImageView: UIImageView?
    var moneyLabel: UILabel?
    var isSelected: Bool = false {
        willSet {
            if newValue {
                arrowImageView!.image = UIImage(named: "cell_arrow_up_accessory")
            } else {
                arrowImageView!.image = UIImage(named: "cell_arrow_down_accessory")
            }
        }
    }
    let lineView = UIView()
    
    weak var delegate: MoneyTableViewHeadDelegate?
    
    var question: String? {
        didSet {
            questionLabel?.text = question
        }
    }
    var money: String? {
        didSet{
           moneyLabel?.text = money
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.whiteColor()
        
        questionLabel = UILabel()
        questionLabel?.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(questionLabel!)
        
        moneyLabel = UILabel()
        moneyLabel?.font = UIFont.systemFontOfSize(15)
        contentView.addSubview(moneyLabel!)
        
        arrowImageView = UIImageView(image: UIImage(named: "cell_arrow_down_accessory"))
        contentView.addSubview(arrowImageView!)
        
        let tap = UITapGestureRecognizer(target: self, action: "headViewDidClick:")
        contentView.addGestureRecognizer(tap)
        
        lineView.alpha = 0.08
        lineView.backgroundColor = UIColor.blackColor()
        contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        questionLabel?.frame = CGRectMake(20, 0, width - 20, height)
        moneyLabel?.sizeToFit()
        moneyLabel?.frame = CGRectMake(width - moneyLabel!.size.width - 35, 0, moneyLabel!.size.width, height)
        arrowImageView?.frame = CGRectMake(width - 30, (height - arrowImageView!.size.height) * 0.5, arrowImageView!.size.width, arrowImageView!.size.height)
        lineView.frame = CGRectMake(0, 0, width, 1)
        
    }
    
    func headViewDidClick(tap: UITapGestureRecognizer) {
        isSelected = !isSelected
        
        if delegate != nil && delegate!.respondsToSelector("headViewDidClck:") {
            
            delegate!.headViewDidClck!(self)
        }
    }
}

@objc protocol MoneyTableViewHeadDelegate: NSObjectProtocol {
    optional
    func headViewDidClck(headView: MoneyTableViewHead)
}

