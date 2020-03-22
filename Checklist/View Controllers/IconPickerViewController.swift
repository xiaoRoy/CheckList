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
    
    weak var delegate: IconPickerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChecklistIcon.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let index = indexPath.row
        let icon = ChecklistIcon.allCases[index]
        if let iconImageView = cell.imageView {
            iconImageView.image = UIImage(named: icon.rawValue)
        }
        let lableIconName = cell.textLabel!
        lableIconName.text = icon.rawValue
        return cell
    }
    
    //MARK: - Table View delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let delegate = delegate {
            let row = indexPath.row
            delegate.iconPicker(self, didPick: ChecklistIcon.allCases[row])
        }
    }
}
