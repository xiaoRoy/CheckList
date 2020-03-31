//
//  Checklist.swift
//  Checklist
//
//  Created by Jerry Li on 2019/12/21.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    var name: String
    var icon: ChecklistIcon
    var checklistItems = Array<ChecklistItem>()
    //    var checklistItmeList = [ChecklistItem]()
    
    //    var checklistItmeList: Array<ChecklistItem> = Array<ChecklistItem>()
    //    var checklistItmeList: Array<ChecklistItem> = [ChecklistItem]()
    //    var checklistItmeList: Array<ChecklistItem> = []
    
    //    var checklistItmeList: [ChecklistItem] = Array<ChecklistItem>()
    //    var checklistItmeList: [ChecklistItem] = [ChecklistItem]()
    //    var checklistItmeList: [ChecklistItem] = []
    
    
    init(name: String, icon: ChecklistIcon = .noIcon) {
        self.name = name
        self.icon = icon
        super.init()
    }
    
    
    func countUnCompletedItems() -> Int {
        return checklistItems.reduce(0, {
            (accumulator: Int, checklistItem: ChecklistItem) -> Int in
            accumulator + (checklistItem.completed ? 0 : 1)
        })
    }
}

enum ChecklistIcon: String, Codable, CaseIterable {
    case noIcon = "No Icon"
    case appointmnets = "Appointments"
    case birthday = "Birthdays"
    case chores = "Chores"
    case drinks = "Drinks"
    case folder = "Folder"
    case groceries = "Groceries"
    case inbox = "Inbox"
    case photos = "Photos"
    case trips = "Trips"
}
