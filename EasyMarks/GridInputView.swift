//
//  GridInputView.swift
//  EasyMarks
//
//  Created by hujia on 16/5/16.
//  Copyright © 2016年 wwh. All rights reserved.
//
//
//  GridInputView.swift
//  huala
//
//  Created by 胡佳 on 15/7/24.
//  Copyright (c) 2015年 hujia. All rights reserved.
//

import UIKit
import Darwin

protocol GridInputViewDelegate: class {
    func gridInputView(inputView: GridInputView, inputCompleted value:String)
}

class GridInputView: UIView {
    
    var title = "请输入支付密码" {
        didSet {
            titleLabel?.text = title
            self.setNeedsDisplay()
        }
    }
    
    var message = "" {
        didSet {
            messageLabel?.text = message
            self.setNeedsDisplay()
        }
    }
    
    var encryption = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    weak var delegate: GridInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var titleLabel: UILabel!
    var messageLabel: UILabel!
    
    var nums = [String]()
    
    func setup() {
        self.backgroundColor = UIColor.clearColor();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKeyboardNotification:", name: GridKeyboard.sNotificationName, object: nil)
        
        titleLabel = UILabel(frame: CGRectMake(screenWidth() * 0.24375 * 0.5, 15, screenWidth() * 0.7, 20))
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFontOfSize(screenWidth() * 0.043125)
        titleLabel.textColor = UIColor.colorFromRGB(0x000000)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = title
        self.addSubview(titleLabel)
        
        messageLabel = UILabel(frame: CGRectMake(screenWidth() * 0.24375 * 0.5, 35, screenWidth() * 0.7, 30))
        messageLabel.numberOfLines = 2
        messageLabel.font = UIFont.systemFontOfSize(screenWidth() * 0.033125)
        messageLabel.textColor = UIColor.colorFromRGB(0x666666)
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.text = message
        self.addSubview(messageLabel)
        
        let closeBtn = UIImageView(frame: CGRectMake(0, 0, 25, 25))
        closeBtn.alpha = 0.5
        closeBtn.image = UIImage(named: "icon_small_close")
        closeBtn.userInteractionEnabled = true
        self.addSubview(closeBtn)
        closeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onClickClose:"))
    }
    
    func onClickClose(recognizer: UITapGestureRecognizer) {
        self.delegate?.gridInputView(self, inputCompleted: "")
    }
    
    func onKeyboardNotification(notification: NSNotification) {
        var userInfo = notification.userInfo as! [String : String]
        let key = GridKey.fromValue(userInfo[GridKeyboard.sKey]!)
        
        switch (key) {
        case let .Value(value):
            self.nums.append(value)
            self.setNeedsDisplay()
            if self.nums.count >= 6 {
                onInputCompleted()
            }
        case .Delete:
            if !self.nums.isEmpty {
                self.nums.removeLast()
                self.setNeedsDisplay()
            }
        default:
            break
        }
    }
    
    func onInputCompleted() {
        var value = ""
        for i in 0...5 {
            value += "\(self.nums[i])"
        }
        
        self.delegate?.gridInputView(self, inputCompleted: value)
    }
    
    override func drawRect(rect: CGRect) {
        // 画图
        let bg = UIImage(named: "grid_password_bg")!
        bg.drawInRect(rect)
        
        // 画密码框
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let field = UIImage(named: "grid_password_in")!
        field.drawInRect(CGRectMake(screenWidth * 0.096875 * 0.5, screenWidth * 0.40625 * 0.5, screenWidth * 0.846875, screenWidth * 0.121875))
        
        // 画标题
        //        var size = title.boundingRectWithSize(CGSizeMake(CGFloat(FLT_MAX), CGFloat(FLT_MAX)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(screenWidth * 0.043125)], context: nil)
        //        var titleRect = CGRectMake((self.frame.size.width - size.width) * 0.5, screenWidth * 0.03125, size.width, size.height);
        //        title.drawInRect(titleRect, withAttributes: [NSFontAttributeName: UIFont.systemFontOfSize(screenWidth * 0.043125), NSForegroundColorAttributeName: UIColor(red: 102 / 255.0, green: 102 / 255.0, blue: 102 / 255.0, alpha: 1.0)])
        //
        //        size = title.boundingRectWithSize(CGSizeMake(CGFloat(FLT_MAX), CGFloat(FLT_MAX)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(screenWidth * 0.043125)], context: nil)
        //        titleRect = CGRectMake((self.frame.size.width - size.width) * 0.5, screenWidth * 0.0625, size.width, size.height);
        //        title.drawInRect(titleRect, withAttributes: [NSFontAttributeName: UIFont.systemFontOfSize(screenWidth * 0.043125), NSForegroundColorAttributeName: UIColor(red: 102 / 255.0, green: 102 / 255.0, blue: 102 / 255.0, alpha: 1.0)])
        
        if encryption {
            // 画点
            let pointImage = UIImage(named: "grid_password_point")!
            let pointW = screenWidth * 0.04;
            let pointH = pointW;
            let pointY = screenWidth * 0.245;
            let margin = screenWidth * 0.0484375;
            let padding = screenWidth * 0.050578125;
            for i in 0..<self.nums.count {
                let pointX = margin + padding + CGFloat(i) * (pointW + 2 * padding);
                pointImage.drawInRect(CGRectMake(pointX, pointY, pointW, pointH))
            }
        } else {
            let pointW = screenWidth * 0.07;
            let pointH = pointW;
            let pointY = screenWidth * 0.23;
            let margin = screenWidth * 0.0684375;
            let padding = screenWidth * 0.035578125;
            
            let attr = [NSFontAttributeName: UIFont.boldSystemFontOfSize(screenWidth * 0.057125), NSForegroundColorAttributeName: UIColor.colorFromRGB(0x000000)]
            
            for i in 0..<self.nums.count {
                let pointX = margin + padding + CGFloat(i) * (pointW + 2 * padding);
                ("\(self.nums[i])" as NSString).drawInRect(CGRectMake(pointX, pointY, pointW, pointH), withAttributes: attr)
            }
        }
        
    }
}
