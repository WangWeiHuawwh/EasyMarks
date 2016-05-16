//
//  CommenViewController.swift
//  EasyMarks
//
//  Created by hujia on 16/5/10.
//  Copyright © 2016年 wwh. All rights reserved.
//
import UIKit

class CommenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommenViewController.keyboardHide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = LFBGlobalBackgroundColor
    }
    
    func keyboardHide(tap: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}