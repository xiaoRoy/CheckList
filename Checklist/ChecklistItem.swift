//
//  CheckListItem.swift
//  Checklist
//
//  Created by Jerry Li on 2019/7/6.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var todo = ""
    var completed = false
    
    func toggle() {
        completed = !completed
    }
}
