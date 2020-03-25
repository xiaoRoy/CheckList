//
//  CheckListItem.swift
//  Checklist
//
//  Created by Jerry Li on 2019/7/6.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    
    var itemId = -1
    var todo: String
    var completed: Bool
    var dueDate  = Data()
    var shouldRemind = false
    
    init(todo: String = "", completed: Bool = false) {
        self.todo = todo
        self.completed = completed
        super.init()
    }
    
    func toggle() {
        completed = !completed
    }
}
