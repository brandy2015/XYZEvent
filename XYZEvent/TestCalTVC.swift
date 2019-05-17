//
//  TestCalTVC.swift
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

class TestCalTVC: UITableViewController {
    var Calendars: [EKEvent]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        刷新新导入的方法()
        self.refreshControl = UIRefreshControl()
        //添加刷新
        refreshControl?.addTarget(self, action: #selector(刷新新导入的方法),for: .valueChanged)
    }
    
    @objc func 刷新新导入的方法()  {
        DispatchQueue.main.async{
            self.refreshControl?.beginRefreshing()
        }
//        afterDelay(0.7) {
            XYZEvent.Calendar.FetchLocalCalendarEvent前后90天(GetBackEvent: { (Calendars) in
                
                
                if let Calendars = Calendars{
                    
                    self.Calendars = Calendars.sorted(by: { (s1, s2) -> Bool in
                        s1.creationDate ?? Date() < s2.creationDate ?? Date()
                    })
                    print("😺😺😺😺")
                    
                    //这里需要访问notes所以加的
                    for i in Calendars{print(i.notes as Any)}
                    
                    
                    DispatchQueue.main.async{
                        self.tableView?.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }else{
                    self.Calendars = nil
                    print("获取提醒失败！需要授权允许对提醒事项的访问。")
                }
            })
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.Calendars?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle,reuseIdentifier: "CalendarCell")
        //时间近的降序排列
        self.Calendars.sort { (s1, s2) -> Bool in
            return s1.creationDate ?? Date() > s2.creationDate ?? Date()
        }
        
        let CalendarX:EKEvent! = self.Calendars![indexPath.row]
        //提醒事项的内容
        cell.textLabel?.text = CalendarX.title
        
        //提醒事项的时间
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let time = ((CalendarX.creationDate ?? XYZTime.Now) + 8.hours).XYZToString(format: "yyyy-MM-dd HH:mm")
        cell.detailTextLabel?.text = "\(String(describing: CalendarX.creationDate))"//time
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    //    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let CalendarsX = self.Calendars[indexPath.row]
            XYZEvent.Calendar.delete(id: CalendarsX.calendarItemExternalIdentifier, succeeded: {
                DispatchQueue.main.async{
                    // Delete the row from the data source
                    self.Calendars.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }) {print("提示删除失败")}
            //            记录是否保存进了系统的提醒事项和日历中，并保持同步
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let CalendarX = Calendars[indexPath.row]
        CalendarX.title = "哈哈111🈶🈶🈶🈶🈶☺️☺️"
        CalendarX.notes = "第🈶🈶🈶🈶🈶33次更改好了"
        
        CalendarX.CalUpdate(succeeded: {
            self.刷新新导入的方法()
        }) {
            print("没东西")
        }
        
//        XYZEvent.Calendar.Update(with: CalendarX.calendarItemExternalIdentifier, ToNewCalendarX: CalendarX) {(EventXX) in
//            if let EventXX = EventXX{
//                print("🈶🈶🈶🈶🈶")
//                print(EventXX)
//                print("Notes")
//                print(EventXX.title)
//                print("Notes")
//                print(EventXX.notes)
//                self.刷新新导入的方法()
//            }else{
//                print("没东西")
//            }
//        }
        

//        XYZEvent.Calendar.Update(CalendarX: CalendarX) { (EventXX) in
//
//            if let EventXX = EventXX{
//
//
//                //    (title:String,notes:String ,startDate:Date = Date(),endDate:Date = Date(),succeeded : @escaping (String?) -> Void,failed : @escaping () -> Void) {
//
//
//
//                print("🈶🈶🈶🈶🈶")
////                print(EventXX)
//                print("Notes")
//                print(EventXX.title)
//                print("Notes")
//                print(EventXX.notes)
//                self.刷新新导入的方法()
//            }else{
//                print("没东西")
//            }
//        }

    }
    
}


    

    

    
    


    

    

    

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AddCalendarNavID"{
//            if let TVCNav = segue.destination as? UINavigationController,let TVC = TVCNav.children.first as? AddCalendarVC{
//
//                TVC.delegate = self
//            }
//        }
//    }

    
    
//}

//extension CalendarListsTVC:AddCalendarVCDelegate {
//    func AfterAddCalendarThenRefresh(_ controller: AddCalendarVC) {
//        controller.dismiss(animated: true, completion: nil)
//        刷新新导入的方法()
//        //时间近的降序排列
//        self.Calendars.sort { (s1, s2) -> Bool in
//            return s1.creationDate ?? Date() > s2.creationDate ?? Date()
//        }
//    }
//}
