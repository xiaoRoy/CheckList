//
//  ViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/2/23.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checkListItemArray: Array = [ChecklistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadChecklistItems()
        // Do any additional setup after loading the view, typically from a nib.
//        navigationController?.navigationBar.prefersLargeTitles = true
//        let todos = ["Walk the dog", "Brush my teeth", "Learn iOS develoment",
//                     "Soccer practice", "Eat ice cream"]
//        for todo in todos {
//            let checkListItem = ChecklistItem()
//            checkListItem.todo = todo
//            checkListItemArray.append(checkListItem)
//        }
//        print("Document folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
//        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ItemDetailViewType.add.rawValue {
            let controller = segue.destination as! ItemDetialViewController
            controller.itemDetailViewControllerDelegate = self
        } else if segue.identifier == ItemDetailViewType.edit.rawValue {
            let controller = segue.destination as! ItemDetialViewController
            controller.itemDetailViewControllerDelegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checkListItemArray[indexPath.row]
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
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(checkListItemArray)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding tiem arry: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                checkListItemArray = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK:- Table View Data Source(UITableViewDataSource)
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
    
    // MARK:- Table View Delegate(UITableViewDelegate)
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = getCheckListItem(at: indexPath)
            item.toggle()
            configureCheckMark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checkListItemArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveChecklistItems()
    }
    
    // MARK:- Item Detial View Controller Delegates
    func itemDetailViewControllerDidCancle(_ controller: ItemDetialViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetialViewController, didFinishAdding item: ChecklistItem) {
        addItemViewForController(controller, didFinishItem: item)
        saveChecklistItems()
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetialViewController, didFininishEditing item: ChecklistItem) {
        if let index = checkListItemArray.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureLabel(for: cell, with: item)
            }
        }
        saveChecklistItems()
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Setup Cell
    func getCheckListItem(at indexPath: IndexPath) -> ChecklistItem {
        return checkListItemArray[indexPath.row % checkListItemArray.count]
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
        
        let newIndex = checkListItemArray.count
        checkListItemArray.append(item)
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with:.automatic)
    }
}

enum ItemDetailViewType: String {
    case add = "AddItem"
    case edit = "EditItem"
}

