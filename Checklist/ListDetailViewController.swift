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

class ListDetailViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
