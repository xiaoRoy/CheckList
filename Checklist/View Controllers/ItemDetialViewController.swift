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

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var barButtonItemDone: UIBarButtonItem!
    
    var itemToEdit: ChecklistItem?
    
    weak var itemDetailViewControllerDelegate: ItemDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.todo
            barButtonItemDone.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
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
            itemDetailViewControllerDelegate?.itemDetailViewController(self, didFininishEditing: checkListItem)
        }  else {
            let item = ChecklistItem()
            item.todo = textField.text!
            itemDetailViewControllerDelegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func cancel() {
        itemDetailViewControllerDelegate?.itemDetailViewControllerDidCancle(self)
    }
}
