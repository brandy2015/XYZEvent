//
//  TestTVC.swift
//  XYZEvent
//
//  Created by 张子豪 on 2019/5/17.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit
//import SoHow
//import SHTManager
//import SwiftDate
//import XYZEvent


class TestTVC: UITableViewController {
    var reminders: [EKReminder]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        刷新新导入的方法()
        //初始化刷新
        self.refreshControl = UIRefreshControl()
        //添加刷新
        refreshControl?.addTarget(self, action: #selector(刷新新导入的方法),for: .valueChanged)
    }
    
    @objc func 刷新新导入的方法()  {
        DispatchQueue.main.async{
            self.refreshControl?.beginRefreshing()
        }
       
            XYZEvent.Reminder.FetchAll { (reminders) in
                if let reminders = reminders{
                    self.reminders = reminders.sorted(by: { (s1, s2) -> Bool in
                        s1.creationDate ?? Date() < s2.creationDate ?? Date()
                    })
                    
                    
                    //这里需要访问notes所以加的，只有访问后才可以在下面访问到
                    for i in self.reminders{print(i.notes as Any)}
                    
                    print(self.reminders.count)
                    DispatchQueue.main.async{
                        self.tableView?.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }else{
                    self.reminders = nil
                    print("获取提醒失败！需要授权允许对提醒事项的访问。")
                }
            }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.reminders?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle,reuseIdentifier: "myCell")
        
        self.reminders.sort { (s1, s2) -> Bool in
            return s1.creationDate ?? Date() > s2.creationDate ?? Date()
        }
        let reminder:EKReminder! = self.reminders![indexPath.row]
        //提醒事项的内容
        cell.textLabel?.text = reminder.title
        cell.detailTextLabel?.text = "\(String(describing: reminder.creationDate))"
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminderX = self.reminders[indexPath.row]
            XYZEvent.Reminder.delete(With: reminderX.calendarItemIdentifier, succeeded: {
                DispatchQueue.main.async{
                    // Delete the row from the data source
                    self.reminders.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }) {print("提示删除失败")}
            //            记录是否保存进了系统的提醒事项和日历中，并保持同步
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let reminderX = reminders[indexPath.row]
        print("第一位置☝️☝️☝️☝️☝️")
        print(reminderX)
        print("id是")
        reminderX.title = "111s```dfasdfsadfsasd"
        reminderX.notes = "1111☺️sddddd"
        
        reminderX.ReminderUpdate(succeeded: {
            print("第2位置☺️☺️☺️☺️☺️")
        
            self.刷新新导入的方法()
        }) {
            print("没有东西")
        }
        
        
//        XYZEvent.Reminder.Update(ReminderX: reminderX) { (itemX) in
//            if let itemX = itemX{
//                print("第2位置☺️☺️☺️☺️☺️")
//                print(itemX)
//                self.刷新新导入的方法()
//            }else{
//                print("没有东西")
//            }
//        }
        
//        XYZEvent.Reminder.Update(With: reminderX.calendarItemIdentifier, ToNewReminderX: reminderX) { (itemX) in
//            if let itemX = itemX{
//                print("第2位置☺️☺️☺️☺️☺️")
//                print(itemX)
//                self.刷新新导入的方法()
//            }else{
//                print("没有东西")
//            }
//        }
        
//        XYZEvent.Reminder.FetchWithId(id: reminderX.calendarItemIdentifier) { (itemX) in
//
//            if let itemX = itemX{
//                print("第2位置☺️☺️☺️☺️☺️")
//                print(itemX)
//            }else{
//                print("没有东西")
//            }
//
//        }
        
        
//        PresentVCBack(With: "ReminderToUpdateNaVCID") { (BackVC) in
//
//            if let BackNavc = BackVC as? UINavigationController , let UpdateReminderVCX = BackNavc.children.first as? UpdateReminderVC{
//                let reminderX = self.reminders[indexPath.row]
//
//                UpdateReminderVCX.ReminderToUpdate = reminderX
//
//            }
//        }
        //
    }
}



