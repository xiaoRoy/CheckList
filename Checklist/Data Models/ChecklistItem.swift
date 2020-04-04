//
//  CheckListItem.swift
//  Checklist
//
//  Created by Jerry Li on 2019/7/6.
//  Copyright © 2019 Jerry Li. All rights reserved.
//


import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    
    var itemId = -1
    var todo: String
    var completed: Bool
    var dueDate  = Date()
    var shouldRemind = false
    
    init(todo: String = "", completed: Bool = false) {
        self.todo = todo
        self.completed = completed
        itemId = DataModel.nextChecklistItemId()
        super.init()
    }
    
    func toggle() {
        completed = !completed
    }
    
    func scheduleNotification() {
        if shouldRemind && dueDate > Date() {
            let conent = UNMutableNotificationContent()
            conent.title = "Reminder:"
            conent.body = todo
            conent.sound = UNNotificationSound.default
            
            
            var dueDateComponent = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            if let minute = dueDateComponent.minute {
                dueDateComponent.minute = minute - 30
            }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dueDateComponent, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemId)", content:conent , trigger: trigger)
    
            UNUserNotificationCenter.current().add(request)
        }
    }
}
