//
//  XYZReminder.swift

//
//  Created by 张子豪 on 2019/5/4.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit

public class XYZReminderKit: NSObject {
    
}

// MARK: - CRUD methods
//增加(Create)、读取查询(Retrieve)、更新(Update)和删除(Delete)

// MARK:- Create--(添加)
public extension XYZReminderKit{
    
    func Add(title:String,notes:String,dueDate:Date,dueDateComponents:DateComponents,succeeded : @escaping (String?) -> Void,failed : @escaping () -> Void) {
        //获取"提醒"的访问授权
        let eventStore = EKEventStore()
        let dueDateComponents:DateComponents = dueDateComponents //dueDate.dateComponentFrom()
        eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            DispatchQueue.main.async {
                //创建提醒条目
                let reminder = EKReminder(eventStore: eventStore)
                reminder.title = title
                reminder.notes = notes
                let alarm = EKAlarm(absoluteDate: dueDate)
                reminder.addAlarm(alarm)
                reminder.dueDateComponents = dueDateComponents
                reminder.calendar = eventStore.defaultCalendarForNewReminders()
                //保存提醒事项
                do {try eventStore.save(reminder, commit: true);print("保存成功！")
                    succeeded(reminder.calendarItemIdentifier)
                    //                弹出成功提醒//询问是否跳转至提醒事项中//                    XYZAlert.presentAlert(VC: self)
                }catch{print("创建提醒失败: \(error)")}
            }
        }
        
    }
}

//添加一个提醒事项
public extension Date{
    func AddNewReminder(title:String,notes:String,dueDate:Date,dueDateComponents:DateComponents,succeeded : @escaping (String?) -> Void,failed : @escaping () -> Void) {
        XYZEvent.Reminder.Add(title: title, notes: notes, dueDate: dueDate, dueDateComponents: dueDateComponents, succeeded: succeeded, failed: failed)
    }
}

// MARK:- Retrieve--(读取查询) All--获取所有数据
public extension XYZReminderKit{
    func FetchWithId(id:String,GetBackEvent: @escaping (EKReminder?,EKEventStore?) -> Void) {// 在取得提醒之前，需要先获取授权
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder) {(granted: Bool, error: Error?) in
            guard granted else{print("获取提醒失败！需要授权允许对提醒事项的访问。");GetBackEvent(nil,nil);return}
            // 获取授权后，我们可以得到所有的提醒事项
            let predicate = eventStore.predicateForReminders(in: nil)
            eventStore.fetchReminders(matching: predicate, completion: {
                (remindersX: [EKReminder]?) -> Void in
                guard let reminders = remindersX else{GetBackEvent(nil,nil);return}
                let getBackReminders =  reminders.compactMap({ (getReminder) -> EKReminder? in
                    guard getReminder.calendarItemIdentifier == id else{ GetBackEvent(nil,nil);return nil}
                    //这句必须使用如果不使用闭包返回有问题，需要排查具体原因
                    print("用于对比ReminderX是😺😺😺😺😺😺");print(getReminder as Any)
                    return getReminder
                   
                })
                guard let reminderYes = getBackReminders.first else{GetBackEvent(nil,nil);return}
                DispatchQueue.main.async {GetBackEvent(reminderYes,eventStore)}
            })
        }
    }
    func FetchAll(GetBackEvent: @escaping ([EKReminder]?,EKEventStore?) -> Void) {// 在取得提醒之前，需要先获取授权
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder) {(granted: Bool, error: Error?) in
            guard granted else{print("获取提醒失败！需要授权允许对提醒事项的访问。");GetBackEvent(nil,nil);return}
            // 获取授权后，我们可以得到所有的提醒事项
            let predicate = eventStore.predicateForReminders(in: nil)
            eventStore.fetchReminders(matching: predicate, completion: {(reminders: [EKReminder]?) -> Void in
                //这句必须使用如果不使用闭包返回有问题，需要排查具体原因
                print(reminders as Any)
                DispatchQueue.main.async {GetBackEvent(reminders,eventStore)}
            })
        }
    }
}

// MARK:- Update--(更新)
public extension XYZReminderKit{
    func Update(ReminderX:EKReminder,GetBackEvent: @escaping ( EKReminder?,EKEventStore?) -> Void) {
        //获取"提醒"的访问授权
        self.FetchWithId(id: ReminderX.calendarItemIdentifier) { (ReminderXToUpdate,eventStoreX) in
        guard let ReminderXToUpdate = ReminderXToUpdate,let eventStore = eventStoreX else{return}
        ReminderXToUpdate.title = ReminderX.title
        ReminderXToUpdate.notes = ReminderX.notes
        ReminderXToUpdate.dueDateComponents = ReminderX.dueDateComponents
            //保存提醒事项
            do {
                try eventStore.save(ReminderXToUpdate, commit: true)
                GetBackEvent(ReminderXToUpdate,eventStoreX);print("保存成功！")
            }catch{ print("保存失败: \(error)")}
        }
    }
    
    func Update(With ID:String,ToNewReminderX:EKReminder  ,GetBackEvent: @escaping ( EKReminder?) -> Void) {
        //获取"提醒"的访问授权
        self.FetchWithId(id: ID) { (ReminderXToUpdate,eventStoreX) in
            if let ReminderXToUpdate = ReminderXToUpdate,let eventStore = eventStoreX {
                ReminderXToUpdate.title = ToNewReminderX.title
                ReminderXToUpdate.notes = ToNewReminderX.notes
                //保存提醒事项
                do {try eventStore.save(ReminderXToUpdate, commit: true)
                    GetBackEvent(ReminderXToUpdate)
                    print("保存成功！")
                }catch{print("保存失败: \(error)")}
            }
        }
    }
    
    // MARK:- 切换任务完成状态
    func toggleComplete(With id:String,succeeded : @escaping () -> Void,failed : @escaping () -> Void) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder, completion: { (granted: Bool, error: Error?) in
            guard granted else{print("获取提醒失败！需要授权允许对提醒事项的访问。");failed();return}
            // 获取授权后，我们可以得到所有的提醒事项
            let predicate = eventStore.predicateForReminders(in: nil)
            eventStore.fetchReminders(matching: predicate, completion: {(remindersX: [EKReminder]?) -> Void in
                guard let reminders = remindersX else{failed();return}
                let getBackReminders =  reminders.compactMap({ (getReminder) -> EKReminder? in
                    guard getReminder.calendarItemIdentifier == id else{ failed();return nil}
                    //这句必须使用如果不使用闭包返回有问题，需要排查具体原因
                    print("用于对比ReminderX是😺😺😺😺😺😺");print(getReminder as Any)
                    return getReminder
                })
                guard let reminderYes = getBackReminders.first else{failed();return}
                DispatchQueue.main.async {
                    //保存提醒事项
                    do {
                        reminderYes.isCompleted =  !reminderYes.isCompleted
                        try eventStore.save(reminderYes, commit: true)
                        succeeded()
                    }catch{failed();print("删除失败: \(error)")}
                }
                        
            })
        })
    }
    //        let formatter = DateFormatter.init()
    //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //        let date = formatter.date(from: "2019-04-26 18:07:00")
}

// MARK:- Delete--(删除)
public extension XYZReminderKit{
    func delete(With id:String,succeeded : @escaping () -> Void,failed : @escaping () -> Void) {
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
}





private var XYZAlert = XYZAlertObject()
private class XYZAlertObject: NSObject {
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








//    func AddNewReminder(title:String)  {
//        let eventStore = EKEventStore()
//        //        let formatter = DateFormatter.init()
//        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        //        let date = formatter.date(from: "2019-04-26 18:07:00")
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
//    }




//根据NSDate获取对应的NSDateComponents对象
//    func dateComponentFromDate(_ date: Date)-> DateComponents{
//        let calendarUnit: Set<Calendar.Component> = [.minute, .hour, .day, .month, .year]
//        let dateComponents = NSCalendar.current.dateComponents(calendarUnit, from: date)
//        return dateComponents
//    }
//
//    //根据NSDate获取对应的DateComponents对象
//    func dateComponentFrom() -> DateComponents{
//        let cal = Calendar.current
//        let dateComponents = cal.dateComponents([.minute, .hour, .day, .month, .year],
//                                                from: self)
//        return dateComponents
//    }
