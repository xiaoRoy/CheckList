//
//  AddItemViewController.swift
//  Checklist
//
//  Created by Jerry Li on 2019/7/7.
//  Copyright © 2019 Jerry Li. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Tabel View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK:- Actions
    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
}
