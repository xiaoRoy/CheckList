//
//  AllListsViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/12/19.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    let cellIdentifier = "CheckListCell"
    
    var allLists = [Checklist]() //Array<CheckList>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func prepareDummyAllLists() {
        allLists.append(Checklist(name: "Birthdays"))
        allLists.append(Checklist(name: "Groceries"))
        allLists.append(Checklist(name: "Groceries"))
        allLists.append(Checklist(name: "To Do"))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "List \(indexPath.row)"
        return cell
    }
    
    // MARK:- Table View Delegate(UITableViewDelegate)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: nil)
    }
}
