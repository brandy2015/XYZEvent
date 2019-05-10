//
//  XYZCalendar.swift
//  testEvent
//
//  Created by 张子豪 on 2019/5/4.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit


//class XYZCalendar: NSObject {
//
//}


//工具函数列表

//XYZCalendarKit().只查询本地日历中的时间前后3个月()

public let XYZCalendar = XYZCalendarKit()
public class XYZCalendarKit{
    
    public func AddCalendarEvent(title:String,notes:String ,startDate:Date = Date(),endDate:Date = Date(),succeeded : @escaping () -> Void,failed : @escaping () -> Void) {
        let eventStore = EKEventStore()
        
        // 'EKEntityType.reminder' or 'EKEntityType.event'
        eventStore.requestAccess(to: .event, completion: {
            granted, error in
            
            guard granted  else{
                print("没有授予权限，需要跳出弹出框提示用户进行跳转权限修改")
                //失败后执行
                failed()
                return
            }
            
            if let error = error{
                print("错误信息")
                print(error)
                //失败后执行
                failed()
            }else{
                
                // 新建一个日历
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = notes
                
                //此处可以修改提醒事项在哪个空间
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                    print("Saved Event")
                    //成功后执行
                    succeeded()
                }catch{
                    //保存失败并提醒，跳出提醒，提醒失败内容
                    print("保存失败")
                    print(error)
                    //失败后执行
                    failed()
                }
                
            }
            
        })
    }
    
    public func FetchAllCalendars前后90天(With DateX:Date = Date(),GetBackEvent: @escaping ([EKEvent]?) -> Void) {
        
        let eventStore = EKEventStore()
        // 请求日历事件
        eventStore.requestAccess(to: .event, completion: {
            granted, error in
            
            guard granted else{
                print("授权失败，需要跳转到权限界面，并且跳出Alert")
                return
            }
            
            if let error = error{
                print("有错误，需要提醒")
                print(error)
            }else{
                // 获取所有的事件（前后90天）
                let startDate = DateX.addingTimeInterval(-3600*24*90)
                let endDate = DateX.addingTimeInterval(3600*24*90)
                let predicate2 = eventStore.predicateForEvents(withStart: startDate,
                                                               end: endDate, calendars: nil)
                print("查询范围 开始:\(startDate) 结束:\(endDate)")
                let eventsX = eventStore.events(matching: predicate2)
                for i in eventsX {
                    print("🐒")
                    print("标题     \(String(describing: i.title))" )
                    print("开始时间: \(String(describing: i.startDate))" )
                    print("结束时间: \(String(describing: i.endDate))" )
                    print("ID:      \(String(describing: i.eventIdentifier))" )
                    print("🐒🐒")
                }
                //返回Event
                GetBackEvent(eventsX)
                
            }
        })
    }
    //
    //    3，功能改进：只查询本地日历中的事件
    //    从上面的运行结果可以看出，我们把系统中所有的日历事件都查询出来了，不管是本地日历事件（如果有iCloud同步则是iCloud日历），还是系统自带的节假日、生日日历事件。如果我们只关注本地日历事件，可以在查询的时候添加个日历参数即可。代码如下。
    //
    public func FetchLocalCalendarEvent前后90天(With DateX:Date = Date(),GetBackEvent: @escaping ([EKEvent]?) -> Void) {
        
        let eventStore = EKEventStore()
        // 请求日历事件
        eventStore.requestAccess(to: .event, completion: {
            granted, error in
            
            guard granted else{
                print("授权失败，需要跳转到权限界面，并且跳出Alert")
                return
            }
            
            if let error = error{
                print("有错误，需要提醒")
                print(error)
            }else{
                //获取本地日历（剔除节假日，生日等其他系统日历）
                let calendars = eventStore.calendars(for: .event).filter({
                    (calender) -> Bool in
                    return calender.type == .local || calender.type == .calDAV
                })
                
                // 获取所有的事件（前后90天）
                let startDate = DateX.addingTimeInterval(-3600*24*90)
                let endDate = DateX.addingTimeInterval(3600*24*90)
                let predicate2 = eventStore.predicateForEvents(withStart: startDate,
                                                               end: endDate, calendars: calendars)
                print("查询范围 开始:\(startDate) 结束:\(endDate)")
                let eventsX = eventStore.events(matching: predicate2)
                
                for i in eventsX {
                    print("🐒")
                    print("标题  \(String(describing: i.title))" )
                    print("开始时间: \(String(describing: i.startDate))" )
                    print("结束时间: \(String(describing: i.endDate))" )
                    print("ID: \(String(describing: i.eventIdentifier))" )
                    print("🐒🐒")
                }
                //返回Event
                GetBackEvent(eventsX)
            }
        })
    }
    
    
    
    public func deleteCalendars(id:String,succeeded : @escaping () -> Void,failed : @escaping () -> Void) {
        
        print("XXXXXXXX!!!!!!1111")
        let eventStore = EKEventStore()
        //        let formatter = DateFormatter.init()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        let date = formatter.date(from: "2019-04-26 18:07:00")
        eventStore.requestAccess(to: .event, completion: { (granted: Bool, error: Error?) in
            print("XXXXXXXX!!!!!!22222")
            
            if granted{
                //获取本地日历（剔除节假日，生日等其他系统日历）
                let calendars = eventStore.calendars(for: .event).filter({
                    (calender) -> Bool in
                    return calender.type == .local || calender.type == .calDAV
                })
                // 获取所有的事件（前后90天）
                let startDate = Date().addingTimeInterval(-3600*24*90)
                let endDate = Date().addingTimeInterval(3600*24*90)
                let predicate2 = eventStore.predicateForEvents(withStart: startDate,
                                                               end: endDate, calendars: calendars)
                print("查询范围 开始:\(startDate) 结束:\(endDate)")
                let eventsX = eventStore.events(matching: predicate2)
                
                //遍历所有提醒并删除
                for Calendar in eventsX {
                    if Calendar.calendarItemExternalIdentifier == id{
                        //保存提醒事项
                        do {
                            try eventStore.remove(Calendar, span: .thisEvent)
                            print("删除成功！")
                            succeeded()
                        }catch{failed();print("删除失败: \(error)")}
                    }
                }
            }else{print("获取提醒失败！需要授权允许对提醒事项的访问。")}
        })
    }
    
    
}


//不成熟函数
//1
//        let formatter = DateFormatter.init()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = formatter.date(from: "2019-04-26 19:05:00")
//
