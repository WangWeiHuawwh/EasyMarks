//
//  MoneyDetailCell.swift
//  EasyMarks
//
//  Created by hujia on 16/5/11.
//  Copyright © 2016年 wwh. All rights reserved.
//

import UIKit
class MoneyDetailCell: UITableViewCell {
    
    static private let identifier: String = "cellID"
    private let lineView = UIView()
    
    var detail: MoneyDeatil? {
        didSet {
            var textY: CGFloat = 0
            var height: CGFloat = 0
            let textLabel = UILabel(frame: CGRectMake(20, textY, ScreenWidth - 40,CGFloat.max))
            textLabel.text = "\(detail?.texts! ?? "" )"
            textLabel.numberOfLines = 0
            textLabel.textColor = UIColor.grayColor()
            textLabel.font = UIFont.systemFontOfSize(14)
            textLabel.sizeToFit()
            height = textLabel.frame.height
            textLabel.frame = CGRectMake(20, 10, ScreenWidth - 40, height)
            let timeLabel = UILabel(frame: CGRectMake(20, textY, ScreenWidth - 40,CGFloat.max))
            timeLabel.text = detail?.date! ?? ""
            timeLabel.textColor = UIColor.grayColor()
            timeLabel.font = UIFont.systemFontOfSize(14)
            timeLabel.textAlignment = NSTextAlignment.Right
            timeLabel.sizeToFit()
            timeLabel.frame = CGRectMake(20, height+20, ScreenWidth - 40, timeLabel.frame.height)
            height = height + timeLabel.frame.height
            detail!.cellHeight = height + 40
            contentView.addSubview(textLabel)
            contentView.addSubview(timeLabel)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.None
        lineView.alpha = 0.25
        lineView.backgroundColor = UIColor.grayColor()
        contentView.addSubview(lineView)
    }
    
    class func answerCell(tableView: UITableView) -> MoneyDetailCell {
        
        //        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? AnswerCell
        //        if cell == nil {
        let cell = MoneyDetailCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        //        }
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRectMake(20, 0, width - 40, 0.5)
    }
}
