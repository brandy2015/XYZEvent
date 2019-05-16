//
//  ViewController.swift
//  XYZEvent
//
//  Created by 张子豪 on 2019/5/10.
//  Copyright © 2019 张子豪. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    
    @IBAction func ReminderRightsBTN(_ sender: Any) {
        XYZEvent.requestReminderAccess(VC: self)
        

    }
    
    @IBAction func CalRightsBTN(_ sender: Any) {
        XYZEvent.requestCalendarAccess(VC: self)
    }
    
    @IBAction func SelfAppReminder(_ sender: Any) {
        XYZEvent.GetAppSelfAccess(delegate: self, VC: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

