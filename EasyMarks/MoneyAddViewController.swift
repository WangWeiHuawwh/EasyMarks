//
//  MoneyAddViewController.swift
//  EasyMarks
//
//  Created by hujia on 16/5/12.
//  Copyright © 2016年 wwh. All rights reserved.
//

import UIKit

class MoneyAddViewController: CommenViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextEdit: UITextField!
    @IBOutlet weak var typeEdit: UITextField!
    @IBOutlet weak var numberEdit: UITextField!
    @IBOutlet weak var mTextView: UITextView!
    var textViewEidt = false
    private var selectCityPickView: UIPickerView?
    private lazy var typeArray: [String]? = {
        let array = ["吃饭", "交通", "住房", "衣物", "还账", "电子产品","其它"]
        return array
    }()
    private lazy var canSaveButton: UIBarButtonItem? = {
        return UIBarButtonItem.barButton("保存", titleColor: UIColor.blueColor(), target: self, action: #selector(MoneyAddViewController.saveButtonClick))
    }()
    private lazy var noSaveButton: UIBarButtonItem? = {
        return UIBarButtonItem.barButton("保存", titleColor: UIColor.lightGrayColor(), target: self, action: #selector(MoneyAddViewController.saveButtonClick))
    }()
    private var currentSelectedTypeIndex = 0
    init() {
        super.init(nibName: "MoneyAddViewController", bundle: NSBundle(forClass: self.dynamicType))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //typeEdit.userInteractionEnabled = false
        buildNavigationItem()
        buildScrollView()
        buildTypeEdit()
    }
    func buildTypeEdit(){
        selectCityPickView = UIPickerView()
        selectCityPickView!.delegate = self
        selectCityPickView!.dataSource = self
        typeEdit.inputView = selectCityPickView
        typeEdit.inputAccessoryView = buildInputView()
        mTextView.delegate = self
        nameTextEdit.delegate = self
        typeEdit.delegate = self
        numberEdit.delegate = self
    }
    private func buildInputView() -> UIView {
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, ScreenWidth, 40))
        toolBar.backgroundColor = UIColor.whiteColor()
        
        let lineView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 1))
        lineView.backgroundColor = UIColor.blackColor()
        lineView.alpha = 0.1
        toolBar.addSubview(lineView)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.alpha = 0.8
        titleLabel.text = "选择类型"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.frame = CGRectMake(0, 0, ScreenWidth, toolBar.height)
        toolBar.addSubview(titleLabel)
        
        let cancleButton = UIButton(frame: CGRectMake(0, 0, 80, toolBar.height))
        cancleButton.tag = 10
        cancleButton.addTarget(self, action: "selectedTypeTextFieldDidChange:", forControlEvents: .TouchUpInside)
        cancleButton.setTitle("取消", forState: .Normal)
        cancleButton.setTitleColor(UIColor.colorWithCustom(82, g: 188, b: 248), forState: .Normal)
        toolBar.addSubview(cancleButton)
        
        let determineButton = UIButton(frame: CGRectMake(ScreenWidth - 80, 0, 80, toolBar.height))
        determineButton.tag = 11
        determineButton.addTarget(self, action: "selectedTypeTextFieldDidChange:", forControlEvents: .TouchUpInside)
        determineButton.setTitleColor(UIColor.colorWithCustom(82, g: 188, b: 248), forState: .Normal)
        determineButton.setTitle("确定", forState: .Normal)
        toolBar.addSubview(determineButton)
        
        return toolBar
    }
    private func buildNavigationItem() {
        navigationItem.title = "新增"
        let rightItemButton = UIBarButtonItem.barButton("保存", titleColor: UIColor.lightGrayColor(), target: self, action: #selector(MoneyAddViewController.saveButtonClick))
        navigationItem.rightBarButtonItem = rightItemButton
    }
    private func buildScrollView() {
        scrollView.frame = view.bounds
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    func saveButtonClick(){
        if nameTextEdit.text?.characters.count > 0 && typeEdit.text?.characters.count > 0 && numberEdit.text?.characters.count > 0 {
            let moneyModel = MoneyModel(title:nameTextEdit.text!,detail:mTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " !")) ?? "",money:Double(numberEdit.text!)!,type:typeEdit.text!,date:getTimeNow())
            getDbManager().addMonyEntityOne(moneyModel)
            SwiftToast.show("添加成功")
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            SwiftToast.show("信息填写不完全",duration: SwiftToast.DEFAULT_DISPLAY_DURATION, position: .center)
        }
    }
    func selectedTypeTextFieldDidChange(sender: UIButton){
        if(sender.tag == 11){
            if currentSelectedTypeIndex != -1 {
                typeEdit.text = typeArray![currentSelectedTypeIndex]
            }
        }
        typeEdit.endEditing(true)
    }
}
extension MoneyAddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray![row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectedTypeIndex = row
    }
    
}
extension MoneyAddViewController:UITextViewDelegate{
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if !textViewEidt {
            if textView == mTextView {
                mTextView.text = ""
                mTextView.textColor = UIColor.blackColor()
            }
        }
        return true
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView.text.characters.count == 0 {
            textView.textColor = UIColor.lightGrayColor()
            textView.text = "请输入详情(可不填)"
            textViewEidt = false
        }else{
            textViewEidt = true
        }
        return true
    }

}
extension MoneyAddViewController:UITextFieldDelegate{
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if nameTextEdit.text?.characters.count > 0 && typeEdit.text?.characters.count > 0 && numberEdit.text?.characters.count > 0 {
            navigationItem.rightBarButtonItem = canSaveButton
        }else{
            navigationItem.rightBarButtonItem = noSaveButton
        }
        return true
    }

}
