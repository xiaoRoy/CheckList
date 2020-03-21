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


class AllListsViewController: UITableViewController,
ListDetailViewControllerDelegate, UINavigationControllerDelegate, ChecklistViewControllerDelegate {
    
    
    let cellIdentifier = "CheckListCell"
    
    let segueIdentifierShowChecklist = "ShowChecklist"
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("trail:viewDidAppear")
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index > -1 && index < dataModel.allChecklists.count {
            let checkList = dataModel.allChecklists[index]
            performSegue(withIdentifier: segueIdentifierShowChecklist, sender: checkList)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifierShowChecklist {
            let destination = segue.destination as! ChecklistViewController
            destination.checklist = sender as? Checklist
            destination.delegate = self
        } else if segue.identifier == ChecklistDetailType.addChecklist.rawValue {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    //MARK:- ListDetailViewControllerDelegate
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedAdding checklist: Checklist) {
        let newRowIndex = dataModel.allChecklists.count
        dataModel.allChecklists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedEditing checklist: Checklist) {
        if let index = dataModel.allChecklists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.allChecklists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // remove the tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier) in viewDidLoad()
        //        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        //        let checklist = dataModel.allChecklists[indexPath.row]
        //        cell.textLabel?.text = checklist.name
        //        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        //        return cell
        
        let cell: UITableViewCell!
        if let cellToCheck = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = cellToCheck
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        let checklist = dataModel.allChecklists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        if let detailLabel = cell.detailTextLabel {
            detailLabel.text = "\(checklist.countCompletedItems()) Remaining"
        }
        return cell
    }
    
    // MARK:- Table View Delegate(UITableViewDelegate)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let selsctedChecklist = dataModel.allChecklists[index]
        dataModel.indexOfSelectedChecklist = index
        performSegue(withIdentifier: segueIdentifierShowChecklist, sender: selsctedChecklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.allChecklists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let destiantonController = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        destiantonController.delegate = self
        let checklist = dataModel.allChecklists[indexPath.row]
        destiantonController.checklistToEdit = checklist
        navigationController?.pushViewController(destiantonController, animated: true)
    }
    
    
    
    //MARK:- Navigation Controller Delegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("trail:navigationControllerWillShow")
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    
    func checkListDidAddItem(_ hecklistViewController: ChecklistViewController) {
        
    }
    
    func checkListDidToggleItem(_ hecklistViewController: ChecklistViewController, checklist: Checklist) {
        if let index = dataModel.allChecklists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                cell.detailTextLabel!.text = "\(checklist.countCompletedItems()) Remaining."
            }
        }
    }
    
    func checkListDidRemovedItem(_ hecklistViewController: ChecklistViewController) {
        
    }
}
