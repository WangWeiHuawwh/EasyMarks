//
//  ViewController.swift
//  EasyMarks
//
//  Created by hujia on 16/5/10.
//  Copyright © 2016年 wwh. All rights reserved.
//

import UIKit

class MainViewController: CommenViewController {
    var mainList = Array<MainCellModel>()

    @IBOutlet weak var mMainCollctionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主页"
        mainList.append(MainCellModel(image: "product02",name: "花费记"))
        mainList.append(MainCellModel(image: "product02",name: "密码记"))
        mainList.append(MainCellModel(image: "product02",name: "其它记"))
        let layout=UICollectionViewFlowLayout()
        var width = UIScreen.mainScreen().bounds.size.width
        if(width == 414){
            width = UIScreen.mainScreen().bounds.size.width/2 - 30
        }else if(width == 375){
            width = UIScreen.mainScreen().bounds.size.width/2 - 24
        }else{
            width = UIScreen.mainScreen().bounds.size.width/2 - 24
        }
        layout.itemSize = CGSize(width: width,height: width)
//      layout.headerReferenceSize = CGSize(width: 0,height: 20)
//      layout.footerReferenceSize = CGSize(width: 0,height: 20)
        layout.minimumLineSpacing = 5
        mMainCollctionView.setCollectionViewLayout(layout, animated: true)
        mMainCollctionView.backgroundColor = LFBGlobalBackgroundColor
        mMainCollctionView.delegate = self
        mMainCollctionView.dataSource = self
        //mMainCollctionView.pagingEnabled = true
        mMainCollctionView.registerNib(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "maincell")
        mMainCollctionView.registerClass(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        mMainCollctionView.registerClass(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
        
//        let bgColor = UIColor(red: 55/255, green:55/225, blue: 55/255, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = bgColor
    }
}

extension MainViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainList.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellViewControll=collectionView.dequeueReusableCellWithReuseIdentifier("maincell", forIndexPath: indexPath) as! MainCollectionViewCell
        cellViewControll.cellLabel.text = mainList[indexPath.row].nameString
        cellViewControll.cellImageView.backgroundColor = UIColor.blackColor()
        return cellViewControll
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch mainList[indexPath.row].nameString {
        case "花费记":
            self.navigationController?.pushViewController(MoneyViewController(), animated: true)
        case "密码记":
            let mPassword = NSUserDefaults.standardUserDefaults().objectForKey("password")
            if mPassword == nil {
                PayPasswordView.enterWithTitle("设置密码", andMessage: "请记住你的初始密码！！！", andEncrypt: true) {
                    let password = $0
                    if password.isEmpty {
                        return
                    }
                    PayPasswordView.enterWithTitle("再次输入", andMessage: "请再次输入密码", andEncrypt: true) {
                        if $0.isEmpty {
                            return
                        }
                        if password == $0 {
                            NSUserDefaults.standardUserDefaults().setValue(password, forKeyPath: "password")
                        }else{
                            SwiftToast.show("两次密码输入不一致")
                        }
                    }
                }
            }else{
                PayPasswordView.enterWithTitle("验证密码", andMessage: "请输入您的密码", andEncrypt: true) {
                    let password = $0
                    if password.isEmpty {
                        return
                    }
                    if password == mPassword as? String {
                        SwiftToast.show("输入正确")
                    }else{
                        SwiftToast.show("输入错误")
                    }
                }
            }
        default:
            return
        }
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 && kind == UICollectionElementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! HomeCollectionHeaderView
            
            return headView
        }
        
        let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", forIndexPath: indexPath) as! HomeCollectionFooterView
        
        if indexPath.section == 0 && kind == UICollectionElementKindSectionFooter {
            footerView.showLabel()
            footerView.tag = 100
        } else {
            footerView.hideLabel()
            footerView.tag = 1
        }
        return footerView
    }
}


