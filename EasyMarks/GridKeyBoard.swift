//
//  GridKeyBoard.swift
//  EasyMarks
//
//  Created by hujia on 16/5/16.
//  Copyright © 2016年 wwh. All rights reserved.
//
//
//  GridKeyboard.swift
//  huala
//
//  Created by 胡佳 on 15/7/24.
//  Copyright (c) 2015年 hujia. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

protocol GridKeyboardDelegate: class {
    func gridKeyboard(keyboard: GridKeyboard, didKeyClick key: Int)
}

enum GridKey {
    case Unknown
    case Value(String)
    case Delete
    case OK
    
    static func isLegalValue(value : String) -> Bool {
        let letterRegEx = "^[a-zA-Z0-9]$"
        return NSPredicate(format:"SELF MATCHES %@", letterRegEx).evaluateWithObject(value)
    }
    
    static func fromValue(value: String) -> GridKey {
        if isLegalValue(value) {
            return GridKey.Value(value)
        } else if value == "ok" {
            return GridKey.OK
        } else if value == "del" {
            return GridKey.Delete
        }
        
        return GridKey.Unknown
    }
}

class GridKeyboard: UIView {
    
    static let sKey = "key"
    static let sNotificationName = "NotificationName"
    
    weak var delegate: GridKeyboardDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor();
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.whiteColor();
        setup()
    }
    
    func setup() {
        for i in 0...11 {
            // 创建按钮
            let btn = UIButton(type: UIButtonType.Custom)
            self.addSubview(btn)
            // 按钮音效监听
            btn.addTarget(self, action: "playTock", forControlEvents: UIControlEvents.TouchDown)
            // 按钮公共属性
            btn.setBackgroundImage(UIImage(named: "number_bg"), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
            let screenWidth = UIScreen.mainScreen().bounds.size.width
            if (i == 9) {  // 确定按钮
                btn.setTitle("隐藏", forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(screenWidth * 0.046875)
                btn.tag = 10
                btn.hidden = true
            } else if (i == 10) {  // 0 按钮
                btn.setTitle("0", forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: screenWidth * 0.06875)
                btn.tag = 0;
            } else if (i == 11) {  // 删除按钮
                btn.setTitle("删除", forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(screenWidth * 0.046875)
                btn.tag = 11
            } else {  // 其他数字按钮
                btn.setTitle("\(i + 1)", forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: screenWidth * 0.06875)
                btn.tag = i + 1;
            }
            
            btn.addTarget(self, action: "onClickButton:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let totalCol = 3
        let pad = screenWidth() * 0.015625
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        let w = screenWidth() * 0.3125
        let h = screenWidth() * 0.14375
        
        var row = 0
        var col = 0
        for i in 0...11 {
            row = i / totalCol
            col = i % totalCol
            x = pad + CGFloat(col) * (w + pad)
            y = CGFloat(row) * (h + pad) + pad
            let btn = self.subviews[i] as! UIButton
            btn.frame = CGRectMake(x, y, w, h)
        }
    }
    
    
    func onClickButton(button: UIButton) {
        delegate?.gridKeyboard(self, didKeyClick: button.tag)
        NSNotificationCenter.defaultCenter().postNotificationName(GridKeyboard.sNotificationName, object: self, userInfo: [GridKeyboard.sKey: button.tag])
    }
    
    func playTock() {
        var sound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(NSURL.fileURLWithPath("/System/Library/Audio/UISounds/Tock.caf"), &sound);
        AudioServicesPlaySystemSound(sound)
    }
}
