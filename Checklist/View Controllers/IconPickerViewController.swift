//
//  IconPickerViewController.swift
//  Checklist
//
//  Created by Jerry Li on 3/21/20.
//  Copyright © 2020 Jerry Li. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ iconPickerViewController: IconPickerViewController, didPick icon: ChecklistIcon)
}

class IconPickerViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChecklistIcon.allCases.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
}
