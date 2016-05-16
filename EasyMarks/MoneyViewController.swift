//
//  MoneyViewController.swift
//  EasyMarks
//
//  Created by hujia on 16/5/11.
//  Copyright © 2016年 wwh. All rights reserved.
//

import UIKit

class MoneyViewController: CommenViewController {
    var moneyList = Array<MoneyDeatil>()
    @IBOutlet weak var mMoneyTableView: UITableView!
    private var lastOpenIndex = -1
    private var isOpenCell = false
    
    init() {
        super.init(nibName: "MoneyViewController", bundle: NSBundle(forClass: self.dynamicType))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消费记"
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton("添加", titleColor: UIColor.blackColor(),
                                                                      image: UIImage(named: "v2_increase")!,hightLightImage: nil,
                                                                    target: self, action: "rightItemClick", type: ItemButtonType.Right)
//        let moneyLists = getDbManager().getMoneyEntity()
//        for moneyEntity in moneyLists {
//            moneyList.append(MoneyDeatil(moneyModel: moneyEntity))
//        }
        mMoneyTableView.backgroundColor = UIColor.whiteColor()
        mMoneyTableView.registerClass(MoneyTableViewHead.self, forHeaderFooterViewReuseIdentifier: "headView")
        mMoneyTableView.sectionHeaderHeight = 50
        mMoneyTableView.delegate = self
        mMoneyTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        mMoneyTableView.dataSource = self
    }
    override func viewWillAppear(animated: Bool) {
        moneyList.removeAll()
        let moneyLists = getDbManager().getMoneyEntity()
        for moneyEntity in moneyLists {
            moneyList.append(MoneyDeatil(moneyModel: moneyEntity))
        }
        if moneyList.count > 0 {
            emptyView?.removeFromSuperview()
            mMoneyTableView.reloadData()
        }
        else
        {
            self.view.addSubview(getEmptyView())
        }
    }
    var emptyView: UIView?
    func getEmptyView() -> UIView {
        if emptyView == nil {
            let ev = TableEmptyView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            ev.setupWithTips("没有任何记录喔")
            emptyView = ev
            emptyView?.backgroundColor = LFBGlobalBackgroundColor
        }
        
        return emptyView!
    }
    func rightItemClick(){
        self.navigationController?.pushViewController(MoneyAddViewController(), animated: true)
    }
}
extension MoneyViewController:UITableViewDelegate {
}
extension MoneyViewController:UITableViewDataSource,MoneyTableViewHeadDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return moneyList.count ?? 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lastOpenIndex == section && isOpenCell {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if lastOpenIndex == indexPath.section && isOpenCell {
            return moneyList[indexPath.section].cellHeight
        }
        
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MoneyDetailCell.answerCell(tableView)
        cell.detail = moneyList[indexPath.section]
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("headView") as? MoneyTableViewHead
        headView!.tag = section
        headView?.delegate = self
        let question = moneyList[section]
        headView?.question = question.title
        headView?.money = "\(question.moneyModel.money!)$"
        return headView!
    }
    
    func headViewDidClck(headView: MoneyTableViewHead) {
        if lastOpenIndex != -1 && lastOpenIndex != headView.tag && isOpenCell {
            let headView = mMoneyTableView?.headerViewForSection(lastOpenIndex) as? MoneyTableViewHead
            headView?.isSelected = false
            
            let deleteIndexPaths = [NSIndexPath(forRow: 0, inSection: lastOpenIndex)]
            isOpenCell = false
            mMoneyTableView?.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        
        if lastOpenIndex == headView.tag && isOpenCell {
            let deleteIndexPaths = [NSIndexPath(forRow: 0, inSection: lastOpenIndex)]
            isOpenCell = false
            mMoneyTableView?.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            return
        }
        
        lastOpenIndex = headView.tag
        isOpenCell = true
        let insertIndexPaths = [NSIndexPath(forRow: 0, inSection: headView.tag)]
        mMoneyTableView?.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: UITableViewRowAnimation.Top)
    }

}
