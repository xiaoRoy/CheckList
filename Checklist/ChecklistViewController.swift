//
//  ViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/2/23.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var checkListItemArray: Array = [ChecklistItem]()
    let total = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let todos = ["Walk the dog", "Brush my teeth", "Learn iOS develoment",
                     "Soccer practice", "Eat ice cream"]
        for todo in todos {
            let checkListItem = ChecklistItem()
            checkListItem.todo = todo
            checkListItemArray.append(checkListItem)
        }
    }
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checkListItemArray.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",
                                                 for: indexPath)
        let item = getCheckListItem(at: indexPath)
        configureCheckMark(for: cell, with: item)
        configureLabel(for: cell, with: item)
        return cell
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = getCheckListItem(at: indexPath)
            item.toggle()
            configureCheckMark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK:- Setup Cell
    func getCheckListItem(at indexPath: IndexPath) -> ChecklistItem {
        return checkListItemArray[indexPath.row % total]
    }
    
    func configureLabel(for cell: UITableViewCell,
                        with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.todo
    }
    
    func configureCheckMark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        if item.completed {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

