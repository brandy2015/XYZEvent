//
//  XYZReminder.swift
//  testEvent
//
//  Created by 张子豪 on 2019/5/4.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit
public let XYZReminder = XYZReminderKit()

public class XYZReminderKit: NSObject {
    
    public func AddReminder(title:String,dueDateComponents:DateComponents,succeeded : @escaping () -> Void,failed : @escaping () -> Void) {
        //获取"提醒"的访问授权
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            DispatchQueue.main.async {
                //创建提醒条目
                let reminder = EKReminder(eventStore: eventStore)
                print("main refresh")
                reminder.title = title
                reminder.dueDateComponents = dueDateComponents
                reminder.calendar = eventStore.defaultCalendarForNewReminders()
                //保存提醒事项
                do {
                    try eventStore.save(reminder, commit: true)
                    print("保存成功！")
                    succeeded()
                    
                    //                弹出成功提醒
                    //询问是否跳转至提醒事项中
                    //                    XYZAlert.presentAlert(VC: self)
                    
                }catch{
                    print("创建提醒失败: \(error)")
                }
            }
        }
        
    }
    
    
    
    
    
    
    public func deleteReminder(id:String,succeeded : @escaping () -> Void,failed : @escaping () -> Void) {
        let eventStore = EKEventStore()
        //        let formatter = DateFormatter.init()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        let date = formatter.date(from: "2019-04-26 18:07:00")
        eventStore.requestAccess(to: .reminder, completion: { (granted: Bool, error: Error?) in
            
            if granted{
                
                // 获取授权后，我们可以得到所有的提醒事项
                let predicate = eventStore.predicateForReminders(in: nil)
                eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    
                    //遍历所有提醒并删除
                    for reminder in reminders! {
        
                        if reminder.calendarItemIdentifier == id{
                            //保存提醒事项
                            do {
                                try eventStore.remove(reminder, commit: true)
                                print("删除成功！")
                                succeeded()
                            }catch{failed();print("删除失败: \(error)")}
                        }
                    }
                })
            }else{print("获取提醒失败！需要授权允许对提醒事项的访问。")}
        })
    }
    
    
    
    public func FetchAllReminders(GetBackEvent: @escaping ([EKReminder]?) -> Void) {
        // 在取得提醒之前，需要先获取授权
        let eventStore = EKEventStore()
        //        let formatter = DateFormatter.init()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        let date = formatter.date(from: "2019-04-26 18:07:00")
        //        eventStore.requestAccess(to: .reminder, completion: { _,error in
        //            let reminder = EKReminder(eventStore: eventStore)
        //
        //            reminder.title = title //"今天要运动"
        //
        //
        //            let dueDate = self.dateComponentFromDate(self)
        //            reminder.dueDateComponents = dueDate
        //            reminder.calendar = eventStore.defaultCalendarForNewReminders();
        //            //            添加闹钟
        //            let alarm = EKAlarm.init(relativeOffset: -5)
        //            reminder.addAlarm(alarm);
        //            do {
        //                //                try self.eventStore.save(event, span: span)
        //                try eventStore.save(reminder, commit: true)
        //                print("保存成！")
        //            }catch{
        //                print("创建失败: \(error)")
        //            }
        //        })
        
        
        eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            
            if granted{
                // 获取授权后，我们可以得到所有的提醒事项
                let predicate = eventStore.predicateForReminders(in: nil)
                eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    //这句必须使用如果不使用闭包返回有问题，需要排查具体原因
                    print(reminders as Any)
                    GetBackEvent(reminders)
                    
                    
                })
            }else{
                print("获取提醒失败！需要授权允许对提醒事项的访问。")
            }
        }
        
        
        
    }
    
    
    public func EditReminder(ID:String,title:String = "修改成功")  {
        //获取"提醒"的访问授权
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) -> Void in
            
            if granted{
                // 获取授权后，我们可以得到所有的提醒事项
                let predicate = eventStore.predicateForReminders(in: nil)
                eventStore.fetchReminders(matching: predicate, completion: {
                    (reminders: [EKReminder]?) -> Void in
                    
                    //遍历所有提醒并修改
                    for reminder in reminders! {
                        if reminder.calendarItemIdentifier == ID{
                            reminder.title = title
                            reminder.calendar = eventStore.defaultCalendarForNewReminders()
                            //保存提醒事项
                            do {
                                try eventStore.save(reminder, commit: true)
                                print("保存成功！")
                            }catch{
                                print("保存失败: \(error)")
                            }
                        }
                    }
                })
            }else{
                print("获取提醒失败！需要授权允许对提醒事项的访问。")
            }
        }
    }
}


public var XYZAlert = XYZAlertObject()
public class XYZAlertObject: NSObject {
    var alertCon = UIAlertController()
    
    public func Config()  {
        self.alertCon = UIAlertController()
        let saveBTN = UIAlertAction(title: "保存成功", style: .default) { (_) in
            self.alertCon.dismiss(animated: true, completion: nil)
        }
        alertCon.addAction(saveBTN)
    }
    
    public func presentAlert(VC:UIViewController)  {
        Config()
        VC.present(alertCon, animated: true, completion: nil)
        
    }
    
}
//添加一个提醒事项
public extension Date{
    
    func AddNewReminder(title:String)  {
        let eventStore = EKEventStore()
        //        let formatter = DateFormatter.init()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        let date = formatter.date(from: "2019-04-26 18:07:00")
        eventStore.requestAccess(to: .reminder, completion: { _,error in
            let reminder = EKReminder(eventStore: eventStore)
            
            reminder.title = title //"今天要运动"
            
            
            let dueDate = self.dateComponentFromDate(self)
            reminder.dueDateComponents = dueDate
            reminder.calendar = eventStore.defaultCalendarForNewReminders();
            //            添加闹钟
            let alarm = EKAlarm.init(relativeOffset: -5)
            reminder.addAlarm(alarm);
            do {
                //                try self.eventStore.save(event, span: span)
                try eventStore.save(reminder, commit: true)
                print("保存成！")
            }catch{
                print("创建失败: \(error)")
            }
        })
    }
    
    
    
    
    //根据NSDate获取对应的NSDateComponents对象
    func dateComponentFromDate(_ date: Date)-> DateComponents{
        let calendarUnit: Set<Calendar.Component> = [.minute, .hour, .day, .month, .year]
        let dateComponents = NSCalendar.current.dateComponents(calendarUnit, from: date)
        return dateComponents
    }
    
    //根据NSDate获取对应的DateComponents对象
    func dateComponentFrom() -> DateComponents{
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.minute, .hour, .day, .month, .year],
                                                from: self)
        return dateComponents
    }
}
