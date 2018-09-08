//
//  AddItemTableViewController.swift
//  BucketList
//
//  Created by Quang Nguyen on 9/8/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
    
    weak var delegate: AddItemViewControllerDelegate?
    @IBOutlet weak var itemTextField: UITextField!
    
    var item: String?
    var indexPath: IndexPath?
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let text = itemTextField.text else { return }
        delegate?.itemSaved(by: self,
                            withText: text,
                            at: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let editItem = item {
            itemTextField.text = editItem
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
