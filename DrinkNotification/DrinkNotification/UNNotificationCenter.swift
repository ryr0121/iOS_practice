//
//  UNNotificationCenter.swift
//  DrinkNotification
//
//  Created by 김초원 on 2023/01/13.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(by alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요💦"
        content.body = "세계 보건 기구(WHO)에서 권장하는 하루 물 섭취량은 1.5L~2L입니다"
        content.sound = .none
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        self.add(request)
    }
}
