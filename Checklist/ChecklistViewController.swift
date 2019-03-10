//
//  ViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/2/23.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    let items = ["Walk the dog", "Brush my teeth", "Learn iOS develoment",
                 "Soccer practice", "Eat ice cream"]
    
    var itemCheckState = [false, false, false, false, false]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        configureCheckMakr(for: cell, at: indexPath)
        let lable = cell.viewWithTag(1000) as! UILabel
        lable.text = items[indexPath.row % items.count]
        return cell
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let index = indexPath.row % itemCheckState.count
            let isChecked = !itemCheckState[index]
            itemCheckState[index] = isChecked
            if isChecked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureCheckMakr(for cell: UITableViewCell,
                            at indexPath: IndexPath) {
        let index = indexPath.row % itemCheckState.count
        if itemCheckState[index] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }

}

