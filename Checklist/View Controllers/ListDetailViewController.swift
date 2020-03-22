//
//  ListDetailTableViewController.swift
//  Checklist
//
//  Created by Jerry Li on 3/8/20.
//  Copyright © 2020 Jerry Li. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedAdding checklist: Checklist)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    weak var delegate:ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    var checklistType: ChecklistDetailType!
    
    var selectedCheckListIcon = ChecklistIcon.folder
    
    @IBOutlet weak var imageChecklistIcon: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            selectedCheckListIcon = checklist.icon
        }
        iconImage.image = UIImage(named: selectedCheckListIcon.rawValue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let iconPickerViewController = segue.destination as! IconPickerViewController
            iconPickerViewController.delegate = self
        }
    }
    
    
    //MARK:- Actions
    @IBAction
    func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction
    func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.icon = selectedCheckListIcon
            delegate?.listDetailViewController(self, didFinishedEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            checklist.icon = selectedCheckListIcon
            delegate?.listDetailViewController(self, didFinishedAdding: checklist)
        }
    }
    
    //MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let section = indexPath.section
        let iconSection = 1
        return section == iconSection ? indexPath : nil
    }
    
    //MARK:- Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRagne = Range(range, in: oldText)! // covert the NSRange to Rang in the oldText String
        let newText = oldText.replacingCharacters(in: stringRagne, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    //MARK:-  Icon Picker Delegate
    func iconPicker(_ iconPickerViewController: IconPickerViewController, didPick icon: ChecklistIcon) {
        selectedCheckListIcon = icon
        imageChecklistIcon.image = UIImage(named: selectedCheckListIcon.rawValue)
        navigationController?.popViewController(animated: true)
    }
}
