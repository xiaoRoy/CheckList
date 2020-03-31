//
//  AddItemViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/7/7.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    
    func itemDetailViewControllerDidCancle(_ controller: ItemDetialViewController)
    
    func itemDetailViewController(_ controller: ItemDetialViewController, didFinishAdding item: ChecklistItem)
    
    func itemDetailViewController(_ controller: ItemDetialViewController, didFininishEditing item: ChecklistItem)
    
}



class ItemDetialViewController: UITableViewController, UITextFieldDelegate {
    
    private static let dueDateSectionIndex = 1
    
    private static let dueDateSectionRow = 2
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var barButtonItemDone: UIBarButtonItem!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var remindMeSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    
    var itemToEdit: ChecklistItem?
    
    var isDatePickerVisible: Bool = false
    
    weak var itemDetailViewControllerDelegate: ItemDetailViewControllerDelegate?
    
    private var dueDate:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.todo
            barButtonItemDone.isEnabled = true
            remindMeSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    //MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsInSection = 0
        if isDatePickerVisible && section == ItemDetialViewController.dueDateSectionIndex  {
            rowsInSection = 3
        } else {
            rowsInSection = super.tableView(tableView, numberOfRowsInSection: section)
        }
        return rowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if isDatePickerRow(at: indexPath) {
            print("cellForRowAt for date picker")
            cell = datePickerCell
        } else {
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0.0
        if isDatePickerRow(at: indexPath) {
            height = 217.0
        } else {
            height = super.tableView(tableView, heightForRowAt: indexPath)
        }
        return height
    }
    
    private func isDatePickerRow(at indexPath: IndexPath)-> Bool{
        return indexPath.section == ItemDetialViewController.dueDateSectionIndex && indexPath.row == ItemDetialViewController.dueDateSectionRow
    }
    
    //MARK:- Tabel View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK:- Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        print("lower: \(stringRange.lowerBound)")
        print("upper:\(stringRange.upperBound)")
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        barButtonItemDone.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        barButtonItemDone.isEnabled = false
        return true
    }
    
    //MARK:- Actions
    @IBAction func done() {
        if let checkListItem = itemToEdit {
            checkListItem.todo = textField.text!
            checkListItem.shouldRemind = remindMeSwitch.isOn
            checkListItem.dueDate = dueDate
            itemDetailViewControllerDelegate?.itemDetailViewController(self, didFininishEditing: checkListItem)
        }  else {
            let item = ChecklistItem(todo: textField.text!)
            item.shouldRemind = remindMeSwitch.isOn
            item.dueDate = dueDate
            itemDetailViewControllerDelegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func cancel() {
        itemDetailViewControllerDelegate?.itemDetailViewControllerDidCancle(self)
    }
    
    //MARK:- Due Date
    func updateDueDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: Date())
    }
    
    func showDatePicker() {
        isDatePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: ItemDetialViewController.dueDateSectionIndex)
        tableView.insertRows(at: [indexPathDatePicker], with: .automatic)
    }
}
