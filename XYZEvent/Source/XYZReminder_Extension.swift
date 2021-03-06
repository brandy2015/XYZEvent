//
//  XYZReminder_Extension.swift
//  XYZEvent
//
//  Created by 张子豪 on 2019/5/17.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit

class XYZReminder_Extension: NSObject {}
// MARK: - CRUD methods
//增加(Create)、读取查询(Retrieve)、更新(Update)和删除(Delete)
// MARK:- Create--(添加)
public extension EKReminder{}
// MARK:- Retrieve--(读取查询) All--获取所有数据
public extension EKReminder{}
// MARK:- Update--(更新)
public extension EKReminder{}
// MARK:- Delete--(删除)
public extension EKReminder{}

// MARK:- Create--(添加)
public extension EKReminder{
    func ReminderSave(succeeded : (() -> Void)? = nil,failed : (() -> Void)? = nil ){
        //获取"提醒"的访问授权
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder) {
            (granted: Bool, error: Error?) in
            DispatchQueue.main.async {
                guard granted  else{failed?();print("没有授予权限，需要跳出弹出框提示用户进行跳转权限修改");return}//失败后执行
                do {//保存提醒事项
                    try eventStore.save(self, commit: true)
                    print("保存成功！")
                    if let succeeded = succeeded{ succeeded()}
                }catch{failed?();print("创建提醒失败: \(error)")}//失败后执行
            }
        }
    }
}

public extension String{// MARK:- Retrieve--(读取查询) All--获取所有数据
    func FetchWithID(GetBackEvent: @escaping (EKReminder?,EKEventStore?) -> Void,succeeded : (() -> Void)? = nil,failed : (() -> Void)? = nil ){
        XYZEvent.Reminder.FetchWithId(id: self, GetBackEvent: GetBackEvent)
    }
}
public extension EKReminder{// MARK:- Update--(更新)
    func ReminderUpdate(succeeded : (() -> Void)? = nil,failed : (() -> Void)? = nil ){
        XYZEvent.Reminder.Update(ReminderX: self) { (eventXX,_)  in
            if let _ = eventXX{if let succeeded = succeeded{succeeded()}}else{if let failed = failed{failed()}}
        }
    }
}
public extension EKReminder{// MARK:- Delete--(删除)
    func ReminderDelete(succeeded : (() -> Void)? = nil,failed : (() -> Void)? = nil ){
        XYZEvent.Reminder.delete(With: self.calendarItemIdentifier, succeeded: {
            if let succeeded = succeeded{ succeeded()}
        }) {if let failed = failed{failed()}}
    }
}
