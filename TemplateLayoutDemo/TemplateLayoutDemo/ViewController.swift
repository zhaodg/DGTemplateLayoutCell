//
//  ViewController.swift
//  TemplateLayoutDemo
//
//  Created by zhaodg on 11/26/15.
//  Copyright © 2015 zhaodg. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var feedList: [[DGFeedItem]] = []
    var jsonData: [DGFeedItem] = []

    @IBOutlet weak var cacheModeSegmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dg_debugLogEnabled = true

        self.cacheModeSegmentControl.selectedSegmentIndex = 1

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let path: String = NSBundle.mainBundle().pathForResource("Data", ofType: "json")!
            let data: NSData = NSData(contentsOfFile: path)!
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                let array: [AnyObject] = dict["feed"] as! [AnyObject]
                for item in array {
                    if let item = item as? NSDictionary {
                        self.jsonData.append(DGFeedItem(dict: item))
                    }
                }
            } catch {
                print("serialization failed!!!")
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.feedList.append(self.jsonData)
                self.tableView.reloadData()
            })
        }
    }

    @IBAction func refreshControlAction(sender: UIRefreshControl) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
           self.feedList.removeAll()
            self.feedList.append(self.jsonData)
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }

    @IBAction func rightNavigationItemAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Action", message: "message", preferredStyle: .ActionSheet)
        alert.modalPresentationStyle = .Popover
        let action1 = UIAlertAction(title: "Insert a row", style: .Destructive) { action in
            self.inserRow()
        }
        let action2 = UIAlertAction(title: "Insert a section", style: .Destructive) { action in
            self.insertSection()
        }
        let action3 = UIAlertAction(title: "Delete a section", style: .Destructive) { action in
            self.deleteSection()
        }
        let action4 = UIAlertAction(title: "Insert Rows At Index Paths", style: .Destructive) { action in
            self.insertRowsAtIndexPaths()
        }
        let action5 = UIAlertAction(title: "Delete Rows At Index Paths", style: .Destructive) { action in
            self.deleteRowsAtIndexPaths()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { action in

        }

        alert.addAction(cancel)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(action5)

        self.presentViewController(alert, animated: true, completion: nil)
    }

    func randomItem() -> DGFeedItem {
        let randomNumber: Int = Int(arc4random_uniform(UInt32(self.jsonData.count)))
        var item: DGFeedItem = self.jsonData[randomNumber]
        countDGFeedItemIdentifier += 1
        item.identifier = "unique-id-\(countDGFeedItemIdentifier)"
        return item
    }

    func inserRow() {
        if self.feedList.count == 0 {
            self.insertSection()
        } else {
            self.feedList[0].insert(self.randomItem(), atIndex: 0)
            let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

    func insertSection() {
        self.feedList.insert([self.randomItem()], atIndex: 0)
        self.tableView.insertSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }

    func deleteSection() {
        if self.feedList.count > 0 {
            self.feedList.removeAtIndex(0)
            self.tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

    func insertRowsAtIndexPaths() {
        // demo 以section 0 为例子
        let section = 0
        if self.feedList.count == 0 {
            self.feedList.append([])
        }
        let lastIndex = self.feedList[section].count
        let insertItems = [self.randomItem(), self.randomItem(), self.randomItem(), self.randomItem(), self.randomItem()]
        for item in insertItems {
            self.feedList[section].append(item)
        }

        var indexPaths: [NSIndexPath] = []
        for index in 0..<insertItems.count {
            indexPaths.append(NSIndexPath(forRow: lastIndex + index, inSection: section))
        }

        self.tableView.beginUpdates()
        if self.tableView.numberOfSections < section + 1 {
            self.tableView.insertSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
        } else {
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
        self.tableView.endUpdates()
    }

    func deleteRowsAtIndexPaths() {
        // demo 以section 0 为例子
        let section = 0
        guard self.feedList.count > section + 1 && self.feedList[section].count > 0 else { return }

        let row = self.feedList[section].count - 1
        let indexPath = NSIndexPath(forRow: row, inSection: section)
        self.feedList[section].removeLast()

        guard self.tableView.numberOfSections > section + 1 else { return }

        self.tableView.beginUpdates()
        if self.tableView.numberOfRowsInSection(section) > 1 {
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        } else {
            self.feedList.removeAtIndex(section)
            self.tableView.deleteSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
        }
        self.tableView.endUpdates()
    }
}

// MARK: - UITableViewDelegate
extension ViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.feedList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedList[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DGFeedCell = tableView.dequeueReusableCellWithIdentifier("DGFeedCell", forIndexPath: indexPath) as! DGFeedCell
        if indexPath.row % 2 == 0 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        cell.loadData(self.feedList[indexPath.section][indexPath.row])
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell ?? UITableViewCell()
    }

}

// MARK: - UITableViewDelegate
extension ViewController {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mode: Int = self.cacheModeSegmentControl.selectedSegmentIndex
        switch mode {
        case 0:
            return tableView.dg_heightForCellWithIdentifier("DGFeedCell", configuration: { (cell) -> Void in
                let cell = cell as! DGFeedCell
                cell.loadData(self.feedList[indexPath.section][indexPath.row])
            })
        case 1:
            return tableView.dg_heightForCellWithIdentifier("DGFeedCell", indexPath: indexPath,configuration: { (cell) -> Void in
                let cell = cell as! DGFeedCell
                cell.loadData(self.feedList[indexPath.section][indexPath.row])
            })
        case 2:
            return tableView.dg_heightForCellWithIdentifier("DGFeedCell", key: self.feedList[indexPath.section][indexPath.row].identifier,  configuration: { (cell) -> Void in
                let cell = cell as! DGFeedCell
                cell.loadData(self.feedList[indexPath.section][indexPath.row])
            })
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.feedList[indexPath.section].removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}



