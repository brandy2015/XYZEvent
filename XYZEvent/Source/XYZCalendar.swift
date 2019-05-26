//
//  XYZCalendar.swift
//  testEvent
//
//  Created by 张子豪 on 2019/5/4.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit

//工具函数列表

//XYZCalendarKit().只查询本地日历中的时间前后3个月()

public class XYZCalendarKit{
    
}

// MARK: - CRUD methods
//增加(Create)、读取查询(Retrieve)、更新(Update)和删除(Delete)

// MARK:- Create--(添加)
public extension XYZCalendarKit{
    func Add(title:String,notes:String ,startDate:Date = Date(),endDate:Date = Date(),succeeded : @escaping (String?) -> Void,failed : @escaping () -> Void) {
        
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
                
                
                let alarm = EKAlarm(absoluteDate: endDate)
                
                event.addAlarm(alarm)
                //                reminder.addAlarm(alarm)
                
                //此处可以修改提醒事项在哪个空间
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                    print("Saved Event")
                    
                    succeeded(event.calendarItemExternalIdentifier)
                    
                    //                    print("calendarid是🐒🐒🐒🐒🐒")
                    //                    print(event.calendarItemExternalIdentifier as Any)
                    
                    //成功后执行
                    
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
    
}
// MARK:- Retrieve--(读取查询) All--获取所有数据
public extension XYZCalendarKit{
//    CalendarX.calendarItemExternalIdentifier
    func FetchWith(id:String,GetBackEvent: @escaping (EKEvent?,EKEventStore?) -> Void) {
        
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
                let startDate = Date().addingTimeInterval(-3600*24*90)
                let endDate = Date().addingTimeInterval(3600*24*90)
                let predicate2 = eventStore.predicateForEvents(withStart: startDate,
                                                               end: endDate, calendars: nil)
                print("查询范围 开始:\(startDate) 结束:\(endDate)")
                
                
                
                
                let eventsX = eventStore.events(matching: predicate2)
                for i in eventsX {
//                    print("循环了")
//                    print(i.calendarItemExternalIdentifier)
//                    print(i.eventIdentifier)
                    
                    if i.calendarItemExternalIdentifier == id{
                        //返回Event
//                        print("找到了")
//                        print("🐒")
//                        print("标题     \(String(describing: i.title))" )
//                        print("开始时间: \(String(describing: i.startDate))" )
//                        print("结束时间: \(String(describing: i.endDate))" )
//                        print("ID:      \(String(describing: i.eventIdentifier))" )
//                        print("🐒🐒")
                        GetBackEvent(i,eventStore)
                        break
                    }
                    
                    
                }
            }
        })
    }
    
    
    func FetchAllCalendars前后90天(With DateX:Date = Date(),GetBackEvent: @escaping ([EKEvent]?) -> Void) {
        
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
    func FetchLocalCalendarEvent前后90天(With DateX:Date = Date(),GetBackEvent: @escaping ([EKEvent]?) -> Void) {
        
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
    
}

// MARK:- Update--(更新)
public extension XYZCalendarKit{

    func Update(CalendarX:EKEvent,GetBackEvent: @escaping (EKEvent?) -> Void) {
        
        self.FetchWith(id: CalendarX.calendarItemExternalIdentifier) { (CalendarXToUpdate,eventStoreX) in
            
            if let CalendarXToUpdate = CalendarXToUpdate,let eventStore = eventStoreX {
                CalendarXToUpdate.title = CalendarX.title
                
                CalendarXToUpdate.notes = CalendarX.notes
                CalendarXToUpdate.startDate = CalendarX.startDate
                
                CalendarXToUpdate.endDate = CalendarX.endDate
                
                //保存提醒事项
                do {
                    try eventStore.save(CalendarXToUpdate, span: .thisEvent, commit: true)
                     GetBackEvent(CalendarXToUpdate)
                    
                    print("Update保存成功XX！")
                }catch{
                    print("保存失败: \(error)")
                }
                
                
            }
        }
    }
    
    
    func Update(with id:String,ToNewCalendarX:EKEvent,GetBackEvent: @escaping (EKEvent?) -> Void) {
        self.FetchWith(id: id) { (CalendarXToUpdate,eventStoreX) in
            
            if let CalendarXToUpdate = CalendarXToUpdate,let eventStore = eventStoreX {
                

                CalendarXToUpdate.title = ToNewCalendarX.title
                CalendarXToUpdate.notes = ToNewCalendarX.notes
                CalendarXToUpdate.startDate = ToNewCalendarX.startDate
                CalendarXToUpdate.endDate = ToNewCalendarX.endDate
                
                
                //保存提醒事项
                do {
                    try eventStore.save(CalendarXToUpdate, span: .thisEvent, commit: true)
                    GetBackEvent(CalendarXToUpdate)
                    
                    print("保存成功！")
                }catch{
                    GetBackEvent(nil)
                    print("保存失败: \(error)")
                }
                
                
            }
        }
    }
}
// MARK:- Delete--(删除)
public extension XYZCalendarKit{
    
    
    func delete(id:String,succeeded : @escaping () -> Void,failed : @escaping () -> Void) {
        
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
//添加提醒



//不成熟函数
//1
//        let formatter = DateFormatter.init()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = formatter.date(from: "2019-04-26 19:05:00")
//





//
////请求日历
//func requestCalendars() {
//    // 请求日历事件
//    eventStore.requestAccess(to: .event, completion: {
//        granted, error in
//        if (granted) && (error == nil) {
//            print("granted \(granted)")
//            print("error  \(error)")
//
//            //获取本地日历（剔除节假日，生日等其他系统日历）
//            let calendars = self.eventStore.calendars(for: .event).filter({
//                (calender) -> Bool in
//                return calender.type == .local || calender.type == .calDAV
//            })
//
//            self.events = []
//            //获取当前年
//            let com = Calendar.current.dateComponents([.year], from: Date())
//            let currentYear = com.year!
//            print(currentYear)
//
//            // 获取所有的事件（前后20年）
//            for i in -20...20 {
//                let startDate = self.startOfMonth(year:currentYear+i, month:1)
//                let endDate = self.endOfMonth(year:currentYear+i, month:12,
//                                              returnEndTime:true)
//                print("查询范围 开始:\(startDate) 结束:\(endDate)")
//
//                let predicate2 = self.eventStore.predicateForEvents(
//                    withStart: startDate, end: endDate, calendars: calendars)
//
//                if let eV = self.eventStore.events(matching: predicate2) as [EKEvent]!
//                {
//                    //将获取到的日历事件添加到集合中
//                    self.events.append(contentsOf: eV)
//                }
//            }
//
//            print("事件加载完毕!共\(self.events.count)条数据。")
//            //重新刷新表格数据
//            DispatchQueue.main.async {
//                self.tableView?.reloadData()
//            }
//        }
//    })
//}
////指定年月的开始日期
//func startOfMonth(year: Int, month: Int) -> Date {
//    let calendar = Calendar.current
//    var startComps = DateComponents()
//    startComps.day = 1
//    startComps.month = month
//    startComps.year = year
//    let startDate = calendar.date(from: startComps)!
//    return startDate
//}
//
////指定年月的结束日期
//func endOfMonth(year: Int, month: Int, returnEndTime:Bool = false) -> Date {
//    let calendar = Calendar.current
//    var components = DateComponents()
//    components.month = 1
//    if returnEndTime {
//        components.second = -1
//    } else {
//        components.day = -1
//    }
//    let tem = startOfMonth(year: year, month:month)
//    let endOfYear =  calendar.date(byAdding: components, to: tem)!
//    return endOfYear
//}
//
