//
//  PayPassword.swift
//  EasyMarks
//
//  Created by hujia on 16/5/16.
//  Copyright © 2016年 wwh. All rights reserved.
//

//
//  PayPasswordView.swift
//  huala
//
//  Created by 胡佳 on 15/7/24.
//  Copyright (c) 2015年 hujia. All rights reserved.
//

import UIKit

protocol PayPasswordViewDelegate : class {
    func payPasswordView(view: PayPasswordView, finishWithPassword password:String)
}

class PayPasswordView: UIView, GridInputViewDelegate, GridKeyboardDelegate {
    weak var delegate: PayPasswordViewDelegate?
    var completionCallback: ((String) -> Void)?
    
    var cover: UIButton!
    var input: GridInputView!
    var responsder: UITextField!
    var keyboard: GridKeyboard!
    
    var inputTitle = "请输入支付密码" {
        didSet {
            self.input?.title = inputTitle
        }
    }
    
    var message = "" {
        didSet {
            self.input?.message = message
        }
    }
    
    var inputEncryption = true {
        didSet {
            self.input?.encryption = inputEncryption
        }
    }
    
    init(enableLetter: Bool) {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.clearColor();
        setupCover()
        setupInputView()
        setupKeyboard()
        setupResponsder(enableLetter)
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.clearColor();
        setupCover()
        setupKeyboard()
        setupInputView()
        setupResponsder(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor();
        setupCover()
        setupInputView()
        setupKeyboard()
        setupResponsder(false)
    }
    
    func gridInputView(inputView: GridInputView, inputCompleted value: String) {
        responsder.resignFirstResponder()
        hideKeyboard() {
            (Bool)->Void in
            self.removeFromSuperview()
            self.delegate?.payPasswordView(self, finishWithPassword: value)
            self.completionCallback?(value)
        }
    }
    
    func gridKeyboard(keyboard: GridKeyboard, didKeyClick key: Int) {
        
    }
    
    /** 蒙板 */
    func setupCover() {
        cover = UIButton(type: UIButtonType.Custom)
        self.addSubview(cover)
        cover.backgroundColor = UIColor.blackColor()
        cover.alpha = 0.4
        cover.addTarget(self, action: "coverClick", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func coverClick() {
        
    }
    
    func onClick() {
        responsder.becomeFirstResponder()
    }
    
    /**  输入框 */
    func setupInputView() {
        input = GridInputView()
        self.addSubview(input)
        input.delegate = self
        input.userInteractionEnabled = true
        input.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onClick"))
    }
    
    /** 响应者 */
    func setupResponsder(enableLetter: Bool) {
        responsder = UITextField()
        if enableLetter {
            responsder.keyboardType = UIKeyboardType.Alphabet
        } else {
            responsder.keyboardType = UIKeyboardType.NumberPad
        }
        self.addSubview(responsder)
        responsder.becomeFirstResponder()
        responsder.delegate = self
    }
    
    /** 键盘 */
    func setupKeyboard() {
        keyboard = GridKeyboard()
        //self.addSubview(keyboard)
        keyboard.delegate = self
    }
    
    private var keyboardPopup = false
    func showKeyboard() {
        keyboardPopup = true
        var marginTop: CGFloat = 0
        if (iphone4()) {
            marginTop = 42
        } else if (iphone5()) {
            marginTop = 100
        } else if (iphone6()) {
            marginTop = 120;
        } else if (iphone6p()) {
            marginTop = 140;
        }
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            () -> Void in
            self.keyboard.transform = CGAffineTransformMakeTranslation(0, -self.keyboard.frame.size.height)
            self.input.transform = CGAffineTransformMakeTranslation(0, marginTop - self.input.frame.origin.y)
            }, completion: nil)
    }
    
    func hideKeyboard(completion: (Bool) -> Void) {
        keyboardPopup = false
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            () -> Void in
            self.keyboard.transform = CGAffineTransformIdentity
            self.input.transform = CGAffineTransformIdentity
            }, completion: completion)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cover.frame = self.bounds
    }
    
    func showInView(view: UIView) {
        view.addSubview(self)
        /** 键盘起始frame */
        self.keyboard.frame.origin.x = 0;
        self.keyboard.frame.origin.y = screenHeight();
        self.keyboard.frame.size.width = screenWidth();
        self.keyboard.frame.size.height = screenWidth() * 0.65;
        
        /** 输入框起始frame */
        self.input.frame.size.height = screenWidth() * 0.4625;
        self.input.frame.origin.y = (self.frame.size.height - self.input.frame.size.height) * 0.5;
        self.input.frame.size.width = screenWidth() * 0.94375;
        self.input.frame.origin.x = (screenWidth() - self.input.frame.size.width) * 0.5;
        
        /** 弹出键盘 */
        showKeyboard()
    }
    
    /** 弹出支付密码输入框 */
    class func enter() {
        PayPasswordView().showInView(UIApplication.sharedApplication().keyWindow!)
    }
    
    /** 弹出支付密码输入框，可以修改标题,输入明文还是密文 */
    class func enterWithTitle(title: String, andMessage message:String, andEncrypt encryption: Bool, completedEnter completion: ((String) -> Void)?) -> PayPasswordView {
        let view = PayPasswordView()
        view.showInView(UIApplication.sharedApplication().keyWindow!)
        view.completionCallback = completion
        view.inputTitle = title
        view.message = message
        view.inputEncryption = encryption
        return view
    }
    
    class func enterWithTitle(title: String, andMessage message:String, andEncrypt encryption: Bool, andEnableLetter enable: Bool, completedEnter completion: ((String) -> Void)?) -> PayPasswordView {
        let view = PayPasswordView(enableLetter: enable)
        view.showInView(UIApplication.sharedApplication().keyWindow!)
        view.completionCallback = completion
        view.inputTitle = title
        view.message = message
        view.inputEncryption = encryption
        return view
    }
    
    /** 弹出支付密码输入框，并由completion接收输入的密码 */
    class func enter(completion: ((String) -> Void)?) {
        let view = PayPasswordView()
        view.completionCallback = completion
        view.showInView(UIApplication.sharedApplication().keyWindow!)
    }
}

extension PayPasswordView: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length > 0 && string.isEmpty {
            NSNotificationCenter.defaultCenter().postNotificationName(GridKeyboard.sNotificationName, object: self, userInfo: [GridKeyboard.sKey: "del"])
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(GridKeyboard.sNotificationName, object: self, userInfo: [GridKeyboard.sKey: string])
        }
        print("range:\(range), string:\(string)")
        return true
    }
}
