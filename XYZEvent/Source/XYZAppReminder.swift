//
//  XYZAppReminder.swift
//  XYZEvent
//
//  Created by 张子豪 on 2019/5/16.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

public class XYZAppReminder: NSObject {

}


// MARK: - CRUD methods
//增加(Create)、读取查询(Retrieve)、更新(Update)和删除(Delete)

// MARK:- Create--(添加)
public extension XYZAppReminder{
    
    func Add(dueDate:Date,title:String,body:String,sound: UNNotificationSound? = .default,identifier:String) {
        let content   = UNMutableNotificationContent()
        content.title = title
        //            content.subtitle = self.ToDoListDescriptionX
        content.sound = .default
        content.body  = body
        content.sound = sound
        
        let calendar  = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
        //            print(components)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "\(identifier)", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
        print("Scheduled: \(request) for itemID: \(identifier)")
    }
}

// MARK:- Retrieve--(读取查询) All--获取所有数据

// MARK:- Update--(更新)

// MARK:- Delete--(删除)

public extension XYZAppReminder{
    
    func deactive灭活提醒(identifier:String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(identifier)"])
    }
    
    
}

