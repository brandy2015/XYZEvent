//
//  XYZEvent.swift
//  XYZEvent
//
//  Created by 张子豪 on 2019/5/10.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit

public class XYZEvent: NSObject {
    // MARK: - 系统提醒事项
    public static let Reminder = XYZReminderKit()
    
    // MARK: - 系统日历
    public static let Calendar = XYZCalendarKit()
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
