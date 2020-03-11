//
//  AllListsViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/12/19.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit


enum ChecklistType: String {
    case addChecklist  = "Add Checklist"
    case editCheckList = "Edit CheckList"
}


class AllListsViewController: UITableViewController {
    
    let cellIdentifier = "CheckListCell"
    
    var allLists = [Checklist]() //Array<CheckList>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        prepareDummyAllLists()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let destination = segue.destination as! ChecklistViewController
            destination.checklist = sender as? Checklist
        }
    }
    
    private func prepareDummyAllLists() {
        allLists.append(Checklist(name: "Birthdays"))
        allLists.append(Checklist(name: "Groceries"))
        allLists.append(Checklist(name: "Cool Apps"))
        allLists.append(Checklist(name: "To Do"))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let checklist = allLists[indexPath.row]
        cell.textLabel?.text = checklist.name
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        return cell
    }
    
    // MARK:- Table View Delegate(UITableViewDelegate)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selsctedChecklist = allLists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: selsctedChecklist)
    }
}
