//
//  ColorUtils.swift
//  EasyMarks
//
//  Created by hujia on 16/5/11.
//  Copyright © 2016年 wwh. All rights reserved.
//
import UIKit

extension UIColor {
    
    class func colorWithCustom(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return UIColor.colorWithCustom(r, g: g, b: b)
    }
    class func colorFromRGB(value: Int32) -> UIColor {
        let red = CGFloat(((0xff << 16) & value) >> 16) * 1.0 / 255.0
        let green = CGFloat(((0xff << 8) & value) >> 8) * 1.0 / 255.0
        let blue = CGFloat(0xff & value) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func colorFromRGB(value: Int32, withAlpha alpha: CGFloat) -> UIColor {
        let red = CGFloat(((0xff << 16) & value) >> 16) * 1.0 / 255.0
        let green = CGFloat(((0xff << 8) & value) >> 8) * 1.0 / 255.0
        let blue = CGFloat(0xff & value) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
}
/// 对UIView的扩展
extension UIView {
    /// X值
    var x: CGFloat {
        return self.frame.origin.x
    }
    /// Y值
    var y: CGFloat {
        return self.frame.origin.y
    }
    /// 宽度
    var width: CGFloat {
        return self.frame.size.width
    }
    ///高度
    var height: CGFloat {
        return self.frame.size.height
    }
    var size: CGSize {
        return self.frame.size
    }
    var point: CGPoint {
        return self.frame.origin
    }
}