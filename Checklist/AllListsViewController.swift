//
//  AllListsViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/12/19.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit


enum ChecklistDetailType: String {
    
    case addChecklist  = "AddChecklist"
    case editCheckList = "EditCheckList"
}


class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    
    let cellIdentifier = "CheckListCell"
    
    var allLists = [Checklist]() //Array<CheckList>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        loadChecklists()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let destination = segue.destination as! ChecklistViewController
            destination.checklist = sender as? Checklist
        } else if segue.identifier == ChecklistDetailType.addChecklist.rawValue {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    private func prepareDummyAllLists() {
        let checlistNames:[String] = ["Birthdays", "Groceries", "Coll Apps", "To Do"]
        let checlistArray = checlistNames.map({(checklistName:String) -> (Checklist) in
            let checklist = Checklist(name: checklistName)
            let checcklistItem = ChecklistItem()
            checcklistItem.todo = "Item of \(checklistName)"
            checklist.checklistItems.append(checcklistItem)
            return checklist
        })
        allLists.append(contentsOf: checlistArray)
    }
    
    //MARK:- ListDetailViewControllerDelegate
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedAdding checklist: Checklist) {
        let newRowIndex = allLists.count
        allLists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedEditing checklist: Checklist) {
        if let index = allLists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        allLists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let destiantonController = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        destiantonController.delegate = self
        let checklist = allLists[indexPath.row]
        destiantonController.checklistToEdit = checklist
        navigationController?.pushViewController(destiantonController, animated: true)
    }
    
    //Mark:- Data Saving
    
    func documentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func checklistFilePath() -> URL {
        print(documentDirectory())
        return documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveCheckLists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(allLists)
            try data.write(to: checklistFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array:\(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let path = checklistFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                allLists = try decoder.decode([Checklist].self, from: data)
            }catch {
                print("Error decoding list array:\(error.localizedDescription)")
            }
        }
    }
}
