//
//  CheckListItem.swift
//  Checklist
//
//  Created by Jerry Li on 2019/7/6.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var todo: String
    var completed: Bool
    
    override init() {
        todo = ""
        completed = false
        super.init()
    }
    
    func toggle() {
        completed = !completed
    }
}
