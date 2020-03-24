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
        showTestNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        tableView.reloadData()
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
        dataModel.allChecklists.append(checklist)
        dataModel.sortChecklist()
        if let index = dataModel.allChecklists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedEditing checklist: Checklist) {
        if let index = dataModel.allChecklists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                dataModel.sortChecklist()
                cell.textLabel!.text = checklist.name
                if let iconImage = cell.imageView {
                    iconImage.image = UIImage(named: checklist.icon.rawValue)
                }
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
            detailLabel.text = getCountMessage(for: checklist)
        }
        if let iconImage = cell.imageView {
            iconImage.image = UIImage(named: checklist.icon.rawValue)
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
    
    
    //MARK:- Checklist View Controller Delegate
    private func updateCount(for checklist: Checklist) {
        if let index = dataModel.allChecklists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.detailTextLabel!.text = getCountMessage(for: checklist)
            }
        }
    }
    
    private func getCountMessage(for checklist: Checklist) -> String {
        let message: String!
        if checklist.checklistItems.count == 0 {
            message = "(No Items)"
        } else  {
            let completedCount = checklist.countCompletedItems()
            message = completedCount == 0 ? "All Done!" : "\(completedCount) Ramaining."
        }
        return message
    }
    
    func checkListDidAddItem(_ hecklistViewController: ChecklistViewController, checklist: Checklist) {
        updateCount(for: checklist)
    }
    
    func checkListDidToggleItem(_ hecklistViewController: ChecklistViewController, checklist: Checklist) {
        updateCount(for: checklist)
    }
    
    func checkListDidRemovedItem(_ hecklistViewController: ChecklistViewController, checklist: Checklist) {
        updateCount(for: checklist)
    }
    
    
    private func showTestNotification() {
        print("showTestNotification")
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "I am a local notification"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        let request = UNNotificationRequest(identifier: "FirstNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
}
