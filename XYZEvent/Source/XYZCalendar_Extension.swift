//
//  XYZCalendar_Extension.swift
//  XYZEvent
//
//  Created by 张子豪 on 2019/5/17.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit

class XYZCalendar_Extension: NSObject {
    
}


// MARK: - CRUD methods
//增加(Create)、读取查询(Retrieve)、更新(Update)和删除(Delete)

// MARK:- Create--(添加)
public extension EKEvent{
    func CalSave(succeeded : (() -> Void)? = nil,failed : (() -> Void)? = nil ){
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: {
            granted, error in
            
            guard granted  else{
                print("没有授予权限，需要跳出弹出框提示用户进行跳转权限修改")
                //失败后执行
                if let failed = failed{
                    failed()
                }
                return
            }
            
            if let error = error{
                print("错误信息")
                print(error)
                //失败后执行
                if let failed = failed{
                    failed()
                }
            }else{
                
                //                // 新建一个日历
                //                let event:EKEvent = EKEvent(eventStore: eventStore)
                //                event.title = title
                //                event.startDate = startDate
                //                event.endDate = endDate
                //                event.notes = notes
                //
                //
                //                let alarm = EKAlarm(absoluteDate: endDate)
                //
                //                event.addAlarm(alarm)
                //                reminder.addAlarm(alarm)
                
                //                //此处可以修改提醒事项在哪个空间
                //                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(self, span: .thisEvent)
                    print("Saved Event")
                    
                    
                    if let succeeded = succeeded{
                        succeeded()
                    }
                    //                    print("calendarid是🐒🐒🐒🐒🐒")
                    //                    print(event.calendarItemExternalIdentifier as Any)
                    
                    //成功后执行
                    
                }catch{
                    //保存失败并提醒，跳出提醒，提醒失败内容
                    print("保存失败")
                    print(error)
                    //失败后执行
                    if let failed = failed{
                        failed()
                    }
                    
                }
                
            }
            
        })
        
    }
    
}

// MARK:- Retrieve--(读取查询) All--获取所有数据
public extension String{
    func FetchWithID(GetBackEvent: @escaping (EKEvent?,EKEventStore?) -> Void,succeeded : (() -> Void)? = nil,failed : (() -> Void)? = nil ){
        
        XYZEvent.Calendar.FetchWith(id: self, GetBackEvent: GetBackEvent)
        
    }
    
}
// MARK:- Update--(更新)

public extension EKEvent{
    func CalUpdate(succeeded : (() -> Void)? = nil,failed : (() -> Void)? = nil ){
        
        XYZEvent.Calendar.Update(CalendarX: self, NewDate: self.startDate, ToNewDate: self.endDate) { (eventXX) in
            if let _ = eventXX{
                
                if let succeeded = succeeded{
                    succeeded()
                }
                
            }else{
                if let failed = failed{
                    failed()
                }
                
            }
            
        }
    }
}
// MARK:- Delete--(删除)

public extension EKEvent{
    func CalDelete(succeeded : (() -> Void)? = nil,failed : (() -> Void)? = nil ){
        
        
        XYZEvent.Calendar.delete(id: self.calendarItemExternalIdentifier, succeeded: {
            if let succeeded = succeeded{
                succeeded()
            }
        }) {
            if let failed = failed{
                failed()
            }
        }
        
        
    }
}
