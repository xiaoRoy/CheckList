//
//  ViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/2/23.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit


protocol ChecklistViewControllerDelegate: class {
    func checkListDidAddItem(_ hecklistViewController: ChecklistViewController)
    func checkListDidToggleItem(_ hecklistViewController: ChecklistViewController, checklist: Checklist)
    func checkListDidRemovedItem(_ hecklistViewController: ChecklistViewController)
}

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
//    var checkListItemArray: Array = [ChecklistItem]()
    
    weak var delegate: ChecklistViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ItemDetailViewType.add.rawValue {
            let controller = segue.destination as! ItemDetialViewController
            controller.itemDetailViewControllerDelegate = self
        } else if segue.identifier == ItemDetailViewType.edit.rawValue {
            let controller = segue.destination as! ItemDetialViewController
            controller.itemDetailViewControllerDelegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.checklistItems[indexPath.row]
            }
            
        }
    }
    
    //MARK:- PList
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL{
        return documentsDirectory().appendingPathComponent("CheckList.plist")
    }
    
    // MARK:- Table View Data Source(UITableViewDataSource)
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.checklistItems.count
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
    
    // MARK:- Table View Delegate(UITableViewDelegate)
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = getCheckListItem(at: indexPath)
            item.toggle()
            configureCheckMark(for: cell, with: item)
            delegate?.checkListDidToggleItem(self, checklist: checklist)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.checklistItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK:- Item Detial View Controller Delegates
    func itemDetailViewControllerDidCancle(_ controller: ItemDetialViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetialViewController, didFinishAdding item: ChecklistItem) {
        addItemViewForController(controller, didFinishItem: item)
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetialViewController, didFininishEditing item: ChecklistItem) {
        if let index = checklist.checklistItems.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureLabel(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Setup Cell
    func getCheckListItem(at indexPath: IndexPath) -> ChecklistItem {
        let checklistItemArray = checklist.checklistItems
        return checklistItemArray[indexPath.row % checklistItemArray.count]
    }
    
    func configureLabel(for cell: UITableViewCell,
                        with item: ChecklistItem) {
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = item.todo
        }
//        let label = cell.viewWithTag(1000) as! UILabel
//        label.text = item.todo
    }
    
    func configureCheckMark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        if let label = cell.viewWithTag(1001) as? UILabel {
            label.text = item.completed ? "√" : ""
        }
    }
    
    private func addItemViewForController(_ addItemViewController: ItemDetialViewController, didFinishItem item: ChecklistItem) {
        let newIndex = checklist.checklistItems.count
        checklist.checklistItems.append(item)
        let indexPath = IndexPath(row: newIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with:.automatic)
    }
}

enum ItemDetailViewType: String {
    case add = "AddItem"
    case edit = "EditItem"
}

