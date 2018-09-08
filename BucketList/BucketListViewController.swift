//
//  BucketListViewController.swift
//  BucketList
//
//  Created by Quang Nguyen on 9/8/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class BucketListViewController: UITableViewController {
    var items = ["Sky diving", "Live in Hawaii"]
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
  
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyCell", for: indexPath)
        
        print(cell)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    

    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)

    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController =
            segue.destination as! UINavigationController
        let addItemViewController =
            navigationController.topViewController as! AddItemViewController
        
        addItemViewController.delegate = self

        
        if segue.identifier == "EditItemSegue" {
            
            let indexPath = sender as! IndexPath
            let item = items[indexPath.row]
            
            addItemViewController.delegate = self
            addItemViewController.indexPath = indexPath
            addItemViewController.item = item
        }
    }
    
}

// MARK: - AddItemViewControllerDelegate
extension BucketListViewController: AddItemViewControllerDelegate {
    
    func cancelButtonPressed(by controller: AddItemViewController) {

        dismiss(animated: true, completion: nil)
    }
    
    func itemSaved(by controller: AddItemViewController,
                   withText text: String,
                   at indexPath: IndexPath?) {
        
        if let indexPath = indexPath {
            items[indexPath.row] = text
        } else {
            items.append(text)
        }
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

