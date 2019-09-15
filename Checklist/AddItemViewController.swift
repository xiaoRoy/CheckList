//
//  AddItemViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/7/7.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
//        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: Tabel View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK:- Actions
    @IBAction func done() {
        print("Content of the text field:\(textField.text!)");
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
}
