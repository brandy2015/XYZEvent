//
//  XYZEvent.swift
//  XYZEvent
//
//  Created by 张子豪 on 2019/5/10.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications
public class XYZEvent: NSObject {
    // MARK: - 系统提醒事项
    public static let Reminder = XYZReminderKit()
    // MARK: - 系统日历
    public static let Calendar = XYZCalendarKit()
    // MARK: - App自带的提醒事项Reminder
    public static let AppSelfReminder = XYZAppReminder()
}


public extension XYZEvent{
    //// MARK:-//    获取ing reminder权限
    static func requestReminderAccess(VC:UIViewController) {
        let eventStore = EKEventStore();print("获取ing reminder权限")
        eventStore.requestAccess(to: .reminder) { (Succeeded, errorX) in
            DispatchQueue.main.async {
                if Succeeded{print("成功获取reminder权限")
                }else {      print("获取权限reminder失败")
                    XYZAlert(VC: VC).presentReminder();print(errorX as Any)
        }}}
    }
    
    //// MARK:-//获取ing  Calendar权限
    static func requestCalendarAccess(VC:UIViewController) {print("获取Ing   Calendar权限")
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (Succeeded, errorX) in
            DispatchQueue.main.async {
                if Succeeded{print("成功获取Calendar权限")
                }else {XYZAlert(VC: VC).presentCalendar();print("获取权限Calendar失败");print(errorX as Any)}
            }
        }
    }
    
    //// MARK:-//        获取ing   AppSelf权限 需要
    //        import UserNotifications
    //        XXXXVC:  UNUserNotificationCenterDelegate {
    static func GetAppSelfAccess(delegate:UNUserNotificationCenterDelegate,VC:UIViewController)  {print("获取Ing   AppSelf权限")
        // Notification set up
        let center = UNUserNotificationCenter.current();center.delegate = delegate//        UNUserNotificationCenterDelegate
        //请求通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
            guard accepted else{print("获取AppSelf权限成功");print("用户不允许消息通知。");print("弹出提醒没有权限是否跳转到app设置页面，授予权限");return}
            DispatchQueue.main.async {XYZAlert(VC: VC).presentLocalNoti()}
        }
    }
    
}

private class XYZAlert: NSObject {
    private var alertCon = UIAlertController()
    private var VC :UIViewController? = nil
    
    init(VC:UIViewController) {
        super.init()
        self.VC = VC
    }
    
    private func Config(title:String? = nil, message:String?)  {
        self.alertCon = UIAlertController(title: title, message:message , preferredStyle: .alert)
        let saveBTN = UIAlertAction(title: "跳转到设置", style: .default) { (_) in
            self.JumpToRightsDetail()
            self.alertCon.dismiss(animated: true, completion: nil)
        }
        let cancelBTN = UIAlertAction(title: "取消", style: .cancel) { (_) in
            self.alertCon.dismiss(animated: true, completion: nil)
        }
        
        alertCon.addAction(saveBTN)
        alertCon.addAction(cancelBTN)
        
    }
    
    public func presentLocalNoti()  {
        Config(message: "您没有授予本地通知权限")
        self.VC?.present(alertCon, animated: true, completion: nil)
    }
    public func presentCalendar()  {
        Config(message:"您没有授予访问日历的权限")
        self.VC?.present(alertCon, animated: true, completion: nil)
    }
    public func presentReminder()  {
        Config(message: "您没有授予访问提醒事项的权限")
        self.VC?.present(alertCon, animated: true, completion: nil)
    }

    public func dismiss()  {
        alertCon.dismiss(animated: true, completion: nil)
    }

    
    func JumpToRightsDetail()  {DispatchQueue.main.async {
        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:],completionHandler: {(success) in})
    }}
    
}

//// MARK:-使用项目本身内部提醒LocalNotification
//
//// MARK:-提醒事项
////增加(Create)、读取查询(Retrieve)、更新(Update)和删除(Delete)
//
//// MARK:- Create--(添加)
//extension TodoItemRLObject {
//
//}
//// MARK:- Retrieve  --(读取查询) All--获取所有数据
//extension TodoItemRLObject {
//
//}
//// MARK:- Update    --(更新)
//extension TodoItemRLObject {
//
//}
//// MARK:- Delete    --(删除)
//extension TodoItemRLObject {
//
//}
